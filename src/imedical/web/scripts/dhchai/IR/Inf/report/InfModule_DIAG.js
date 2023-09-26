function InitDiag(obj){
	// 感染诊断
	obj.refreshgridINFDiagnos = function(){
		if(obj.gridINFDiagnos==undefined)
		{
			obj.gridINFDiagnos = $("#gridINFDiagnos").DataTable({
				dom: 'rt',
				paging:false,
				select: 'single',
				ordering: false,
				ajax: {
					"url": "dhchai.query.datatables.csp",
					"data": function (d) {
						d.ClassName = "DHCHAI.IRS.INFDiagnosSrv";
						d.QueryName = "QryINFDiagByRep";
						d.Arg1 = ReportID;
						d.Arg2 = EpisodeID;
						d.ArgCnt = 2;
					}
				},
				columns: [
					{"data": "InfPos"}
					,{"data": "InfSub"}
					,{"data": "InfLoc"}
					,{"data": "InfDate"}
					,{"data": "InfXDate"}
					,{"data": "InfEffect"}
					,{"data": "DeathRelation"}
					,{"data": "InfDiagnosisBasis"}
					,{"data": "InfDiseaseCourse"}
					,{"data": "IsReportDiag","visible":false,}
				]
			});
		}else{
			obj.gridINFDiagnos.ajax.reload(function(){});
		}
	}
	obj.refreshgridINFDiagnos();
	
	// 弹出感染信息弹框
	function OpenINFDiagnosEdit(d,r){
		obj.LayerINFDiagnosEidt = layer.open({
				type: 1,
				zIndex: 100,
				maxmin: false,
				title: "感染信息-编辑", 
				area: ['700px',''],
				content: $('#LayerINFDiagnosEidt'),
				btnAlign: 'c',
				btn: ['保存','取消'],
				yes: function(index, layero){
					INFDiagnosAdd(d,r);
				}
				,success: function(layero){
					InitINFDiagnosEidtData(d);
				}
		});	
	}

	// 初始化感染信息编辑框数据
	function InitINFDiagnosEidtData(d){
		// 渲染控件
		$.form.SelectRender("#cboInfPos");
		$("#cboInfSub").data("param","^");	
		$.form.SelectRender("#cboInfSub");
		$.form.SelectRender('cboInfEffect');
		$("#cboInfLoc").data("param",EpisodeID+"^E");	
		$.form.SelectRender('cboInfLoc');
		// 感染诊断和分类进行关联
		$("#cboInfPos").change(function(){
			var InfPosID = $.form.GetValue("cboInfPos");
			$("#cboInfSub").data("param",InfPosID+"^");	
			$.form.SelectRender("#cboInfSub");
		});
		// 编辑框赋值
		if (d){
			$.form.SetValue("cboInfPos",d.InfPosID,d.InfPos);
			$.form.SetValue("cboInfSub",d.InfSubID,d.InfSub);
			$.form.DateRender('txtInfDate',d.InfDate);
			$.form.DateRender('txtInfXDate',d.InfXDate);
			$.form.SetValue("cboInfLoc",d.InfLocID,d.InfLoc);
			$.form.SetValue("cboInfEffect",d.InfEffectID,d.InfEffect);
			if (d.DeathRelationID!=''){
				var selector = '#chkDeathRelation '+'#'+d.DeathRelationID
				$(selector).iCheck('check');
			}
			$('#txtDiagnosisBasis').val(d.InfDiagnosisBasis);
			$('#txtDiseaseCourse').val(d.InfDiseaseCourse);
			obj.IsReportDiag = d.IsReportDiag;	// 是否临床上报诊断
		}else{
			$.form.SetValue("cboInfPos",'','');
			$.form.SetValue("cboInfSub",'','');
			$.form.DateRender('txtInfDate','');
			$.form.DateRender('txtInfXDate','');
			// 只有一个科室默认选择此科室
			if ($('#cboInfLoc>option').length==2){
				$.form.SetValue("cboInfLoc",$("#cboInfLoc>option:nth-child(2)").val(),$("#cboInfLoc>option:nth-child(2)").text());
			};
			$("input[name='chkDeathRelation']").iCheck('uncheck');
			$('#txtDiagnosisBasis').val('');
			$('#txtDiseaseCourse').val('');
			obj.IsReportDiag = 1;	// 是否临床上报诊断
		}
	}
	
	// 向感染信息列表添加数据
	function INFDiagnosAdd(d,r){
		var InfPosID = $.form.GetValue("cboInfPos");
		if (InfPosID==''){
			var InfPos='';
		}else{
			var InfPos = $.form.GetText("cboInfPos");
		}
		var InfSubID = $.form.GetValue("cboInfSub");
		if (InfSubID==''){
			var InfSub='';
		}else{
			var InfSub = $.form.GetText("cboInfSub");
		}
		var InfDate = $.form.GetValue("txtInfDate");
		var InfLocID = $.form.GetValue("cboInfLoc");
		if (InfLocID==''){
			var InfLoc = '';
		}else{
			var InfLoc = $.form.GetText("cboInfLoc");
		}
		var InfXDate = $.form.GetValue("txtInfXDate");
		var InfEffectID = $.form.GetValue("cboInfEffect");
		if (InfEffectID==''){
			var InfEffect = '';
		}else{
			var InfEffect = $.form.GetText("cboInfEffect");
		}
		var DiagnosisBasis = $.form.GetValue("txtDiagnosisBasis");
		var DiseaseCourse = $.form.GetValue("txtDiseaseCourse");
		var DeathRelationID = '';
		var DeathRelation = '';
        $('input:radio',$("#chkDeathRelation")).each(function(){
       		if(true == $(this).is(':checked')){
            	DeathRelationID=$(this).attr("id");
            	DeathRelation = $(this).parent().parent().text();
       		}
    	})

        if (InfPosID==''){
    		layer.msg('感染诊断不能为空!',{icon: 2});
			return;
    	}

    	// 感染日期
    	if (InfDate==''){
    		layer.msg('感染日期不能为空!',{icon: 2});
			return;
    	}else{
	    	if (!obj.checkDate(InfDate)){
				layer.msg('感染时间需要在住院期间!',{icon: 2});
				return;
			}
		}
    	if (InfLocID==''){
    		layer.msg('感染科室不能为空!',{icon: 2});
			return;
    	}

    	// 感染结束日期 感染转归
    	if (InfXDate!=''){
    		if (!$.form.CompareDate(InfXDate,InfDate)){
    			layer.msg('感染结束日期不能在感染日期之前!',{icon: 2});
				return;
    		}
			if (!obj.checkDate(InfXDate)){
				layer.msg('感染结束日期需在住院期间且不应超出当前日期!',{icon: 2});
				return;
			}
    		if (InfEffectID==''){
		    	layer.msg('感染结束后感染转归不能为空!',{icon: 2});
				return;
		    }
    	}else{
    		// 感染转归为治愈、死亡、好转必填感染结束日期
    		if ((InfEffect=='治愈')||(InfEffect=='死亡')||(InfEffect=='好转')){
    			layer.msg('感染转归为治愈、死亡、好转感染结束日期不能为空!',{icon: 2});
				return;
			}
    	}

    	// 死亡病例、感染转归为死亡，死亡关系必填
    	if (((obj.AdmInfo.record[0].IsDeath=='1')||(InfEffect=='死亡'))&&(DeathRelationID=='')){
    		layer.msg('感染转归为死亡、死亡病例与死亡关系不能为空!',{icon: 2});
				return;
    	};

    	var ID = '';
		if (d) ID = d.ID;
		var row ={
			'ID':ID,
			'EpisodeID':EpisodeID,
			'ReportID':ReportID,
			'InfPosID':InfPosID,
			'InfPos':InfPos,
			'InfSubID':InfSubID,
			'InfSub':InfSub,
			'InfDate':InfDate,
			'InfLocID':InfLocID,
			'InfLoc':InfLoc,
			'InfXDate':InfXDate,
			'InfEffectID':InfEffectID,
			'InfEffect':InfEffect,
			'InfDiagnosisBasis':DiagnosisBasis,
			'InfDiseaseCourse':DiseaseCourse,
			'DeathRelationID':DeathRelationID,
			'DeathRelation':DeathRelation,
			'UpdateUserID':$.LOGON.USERID,
			'IsReportDiag':obj.IsReportDiag		// 是否临床上报诊断
		}
		// 数据重复标志
    	var dataRepeatFlg = 0;
    	for (var i=0;i<obj.gridINFDiagnos.data().length;i++){
    		if (r) {
    			if ($(r).context._DT_RowIndex==i){
    				continue;
    			}
    		}
    		if ((InfPos==obj.gridINFDiagnos.data()[i].InfPos)&&(InfDate==obj.gridINFDiagnos.data()[i].InfDate)){
    			dataRepeatFlg = 1;
    		}
    	}
    	if (dataRepeatFlg == 1) {
    		layer.confirm('存在感染日期、感染诊断相同的记录,是否添加感染信息？', {
			  btn: ['是','否'] //按钮
			}, function(){
				InsertDiagnos(r,row);
			});
    	}else{
    		InsertDiagnos(r,row);
    	};
	}

	function InsertDiagnos(r,row){
		if (r){  //修改
			obj.gridINFDiagnos.row(r).data(row).draw();
		}else{	//添加
			obj.gridINFDiagnos.row.add(row).draw();
		}
		layer.closeAll();
	}
	// 删除感染信息事件
	$("#btnINFDiagnosDel").click(function(e){
		var selectedRows = obj.gridINFDiagnos.rows({selected: true}).count();
		if (selectedRows!== 1 ) {
			layer.msg('请选择一行数据!',{icon: 2});
			return;
		}else{
			var rd = obj.gridINFDiagnos.rows({selected: true}).data().toArray()[0];
			layer.confirm('是否删除感染信息：'+rd.InfPos+'？', {
			  btn: ['是','否'] //按钮
			}, function(){
				obj.gridINFDiagnos.rows({selected:true}).remove().draw(false);
				layer.msg('删除感染信息成功！', {icon: 1});
			});
			// 	obj.gridINFDiagnos.rows({selected:true}).remove().draw(false);
		}
	});

	// 添加感染信息事件
	$("#btnINFDiagnosAdd").click(function(e){
		OpenINFDiagnosEdit('','');
	});

	// 感染信息列表双击事件
	obj.gridINFDiagnos.on('dblclick', 'tr', function(e) {
		var data  = obj.gridINFDiagnos.row(this).data();
		if (typeof(data)=='undefined') return;
		OpenINFDiagnosEdit(data,this);
	});

	obj.DIAG_Save = function()
	{
		// 感染信息
    	var Diags = '';
    	for (var i=0;i<obj.gridINFDiagnos.data().length;i++){
    		var Input = obj.gridINFDiagnos.data()[i].ID;
    		Input = Input + CHR_1 + obj.gridINFDiagnos.data()[i].EpisodeID;
    		Input = Input + CHR_1 + obj.gridINFDiagnos.data()[i].InfPosID;
    		Input = Input + CHR_1 + obj.gridINFDiagnos.data()[i].InfSubID;
    		Input = Input + CHR_1 + obj.gridINFDiagnos.data()[i].InfDate;
    		Input = Input + CHR_1 + obj.gridINFDiagnos.data()[i].InfLocID;
    		Input = Input + CHR_1 + obj.gridINFDiagnos.data()[i].InfDiagnosisBasis;
    		Input = Input + CHR_1 + obj.gridINFDiagnos.data()[i].InfDiseaseCourse;
    		Input = Input + CHR_1 + obj.gridINFDiagnos.data()[i].InfXDate;
    		Input = Input + CHR_1 + obj.gridINFDiagnos.data()[i].InfEffectID;
    		Input = Input + CHR_1 + obj.gridINFDiagnos.data()[i].DeathRelationID;
    		Input = Input + CHR_1 + '';
    		Input = Input + CHR_1 + '';
    		Input = Input + CHR_1 + $.LOGON.USERID;
    		Input = Input + CHR_1 + obj.gridINFDiagnos.data()[i].IsReportDiag;	// 是否临床上报诊断
    		Diags = Diags + CHR_2 + Input;
    	}
    	if (Diags) Diags = Diags.substring(1,Diags.length);
    	return Diags;
	}
	
	//诊断依据
    obj.refreshgridDiagBasis = function(){
		if(obj.gridDiagBasis==undefined)
		{
			obj.gridDiagBasis = $("#gridDiagBasis").DataTable({	
				dom: 'rt',
				//select: 'single',
			    paging: false,
			    "aoColumnDefs": [ 
					{
						"bSortable": false, 
						"aTargets": [ 0 ] 
					}
				],
				info: true,
				ajax: {
					"url": "dhchai.query.datatables.csp",
					"data": function (d) {
						d.ClassName = "DHCHAI.BTS.InfPosGistSrv";
						d.QueryName = "QryInfPosGist";
						var InfPosID = $.form.GetValue("cboInfPos");
						d.Arg1 = "";
						d.Arg2 = InfPosID;
						d.ArgCnt = 2;
					}
				},
				columns: [
		            {"data": "IsChecked",
				        "render": function (data, type, row) {	
							if(data==1){
								return '<div class="icheckbox_square-blue checked" style="margin-top:4px"><input type="checkbox" style="opacity: 0;" checked></div>';
							
							}else{
								return '<div class="icheckbox_square-blue" style="margin-top:4px"><input type="checkbox" style="opacity: 0;"></div>';
							}
						}
			        },
					{"data": "ID","visible": false},
		            {"data": "BTDesc",
					    render: function(data, type, row, meta) { 
							return '<span style="float:left;" title="'+data +'">'+data +'</span>';
				  	 	} 
					},
		            {"data": "TypeDesc",
					    render: function(data, type, row, meta) {
							return '<span style="float:center;" title="'+data +'">'+data +'</span>';
				  	 	}
					},
					{"data": "InfPos","visible": false}
				],
		        "drawCallback": function(settings) {
		            var api = this.api();
		            var rows = api.rows({
		                page: 'current'
		            }).nodes();
		            var last = null;
					
		            api.column(4, {  //根据第5列分组
		                page: 'current'
		            }).data().each(function(group, i) {
		                if (last !== group) {
		                    $(rows).eq(i).before('<tr class="group"><td colspan="2" style="text-align:left">' + group + '</td></tr>');
		                    last = group;
		                }
		            });
		        }
				
			});
		}else{
			obj.gridDiagBasis.ajax.reload(function(){});
		}
	}
	var DiagBasisList="";
    $('#gridDiagBasis tbody').on('click', '.icheckbox_square-blue', function(){
    	if(!$(this).hasClass('checked')){
	    	// 选中
	    	var BTDesc = $(this).parent().next().text(); 	
			$(this).addClass("checked");
			DiagBasisList += BTDesc+" ";
    	}else{
	    	// 取消  	
	    	var BTDesc = $(this).parent().next().text();
			$(this).removeClass("checked");
			DiagBasisList = DiagBasisList.replace(BTDesc+" ","")		
	    }
    });
	//诊断依据
	$("#btnDiagBasis").click(function(e){
		obj.refreshgridDiagBasis();
		obj.LayerBasis = layer.open({
			type: 1,  
			zIndex: 101,
			title: '诊断依据-选择', 
			area: '700px',
			content: $('#LayerDiagBasis'),
			btn: ['确认','取消'],
			btnAlign: 'c',
			yes: function(index, layero){
				var DiagBasis = $.form.GetValue("txtDiagnosisBasis"); 
				if (!DiagBasis) {
					$('#txtDiagnosisBasis').val(DiagBasisList);
				}else {
				    $('#txtDiagnosisBasis').val(DiagBasis+DiagBasisList);
				}
				layer.close(index);
			},end:function (){
				 DiagBasisList="";
			 }
		});
	});
	
    //疾病病程
    obj.refreshgridDiagCourse = function(){
		if(obj.gridDiagCourse==undefined)
		{
			obj.gridDiagCourse = $("#gridDiagCourse").DataTable({
				dom: 'rt',
				paging: false,
				//select: 'single',
				"aoColumnDefs": [ 
					{
						"bSortable": false, 
						"aTargets": [ 0 ] 
					}
				],
				info: true,
				ajax: {
					"url": "dhchai.query.datatables.csp",
					"data": function (d) {
						d.ClassName = "DHCHAI.BTS.DictionarySrv";
						d.QueryName = "QryDic";
						d.Arg1 ="DiseaseCourse";
						d.Arg2 = 1;
						d.ArgCnt = 2;
					}
				},
				columns: [
					{"data": "IsChecked",
				        "render": function (data, type, row) {	
							if(data==1){
								return '<div class="icheckbox_square-blue checked" style="margin-top:4px"><input type="checkbox" style="opacity: 0;" checked></div>';
							
							}else{
								return '<div class="icheckbox_square-blue" style="margin-top:4px"><input type="checkbox" style="opacity: 0;"></div>';
							}
						}
			         },
					{"data": "ID","visible": false},
					{"data": "DicDesc",
					    render: function(data, type, row, meta) { 
							return '<span style="float:left;" title="'+data +'">'+data +'</span>';
				  	 	} 
					}	
				]
			});
		}else {
			obj.gridDiagCourse.ajax.reload(function(){});
		}
    }
	var DiagCourseList="";
    $('#gridDiagCourse tbody').on('click', '.icheckbox_square-blue', function(){
    	if(!$(this).hasClass('checked')){
	    	// 选中
	    	var DicDesc = $(this).parent().next().text(); 	
			$(this).addClass("checked");
			DiagCourseList += DicDesc+" ";
    	}else{
	    	// 取消  	
	    	var DicDesc = $(this).parent().next().text();
			$(this).removeClass("checked");
			DiagCourseList = DiagCourseList.replace(DicDesc+" ","")		
	    }
    });
   
	$("#btnDiagCourse").click(function(e){
		obj.refreshgridDiagCourse();	
		obj.LayerCourse = layer.open({
			type: 1,  
			zIndex: 101,
			title: '感染性疾病病程-选择', 
			area: '500px',
			content: $('#LayerDiagCourse'),
			btn: ['确认','取消'],
			btnAlign: 'c',
			yes: function(index, layero){
				var DiagCourse = $.form.GetValue("txtDiseaseCourse"); 
				if (!DiagCourse) {
					$('#txtDiseaseCourse').val(DiagCourseList);
				}else {
				    $('#txtDiseaseCourse').val(DiagCourse+DiagCourseList);
				}
				layer.close(index);
			},
			end:function (){
				 DiagCourseList="";
			 }
		});
	});

}