//页面Event
function InitHISUIWinEvent(obj){
	//CheckSpecificKey();
	//提交后台保存
	obj.saveVerToSrv=function(node){
		var userID = session['DHCMA.USERID'];
		var pathDr = node.id.split("-")[0];
		var data = $.cm({ClassName:"DHCMA.CPW.BTS.PathFormSrv",MethodName:"AddNewVer",
				"aMastID":pathDr,
				"aUserID":userID
			},false);
		if(parseInt(data)<0){
			$.messager.alert("提示","失败！");
		}else{			
			if (node){
				$('#treeType').tree('reload',node.target);
			}
		}
	};
	//按钮处理事件
	obj.saveEpToSrv=function(){
		var userID = session['DHCMA.USERID'];
		
		var Parref = obj.selVerID;		
		var ID = $("#hID").val();
		var EpDesc = $("#txtDesc").val();
		var EpDesc2 = $("#txtDesc1").val();
		var EpIndNo  = $("#txtIndNo").val();
		var EpDays   = $("#txtEpDays").val();
		var EpIsKeyStep = Common_GetValue("chkEpIsKeyStep")?"1":"0";
		var EpIsOperDay = Common_GetValue("chkEpIsOperDay")?"1":"0";  //itmValue = $this.checkbox('getValue');	
		var EpIsFirstDay = Common_GetValue("chkEpIsFirstDay")?"1":"0";
		var EpIsActive = Common_GetValue("chkActive")?"1":"0";
		
		var errinfo = "";
		if (!EpDesc||EpDesc=="") {
			errinfo = errinfo + "描述不能为空!<br>";
		}
		if (!EpDesc2||EpDesc2=="") {
			errinfo = errinfo + "别名不能为空!<br>";
		}
		if (""==EpIndNo||!obj.numReg(EpIndNo)) {
			errinfo = errinfo + "顺序号不能为空且只能为数值!<br>";
		}
		if (""==EpDays||!obj.numReg(EpDays)) {
			errinfo = errinfo + "阶段天数不能为空且只能为数值!<br>";
		}
		
		if (errinfo!="") {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		
		var InputStr = Parref+"^"+ID;
		InputStr += "^" + EpDesc;
		InputStr += "^" + EpDesc2;
		InputStr += "^" + EpIndNo;
		InputStr += "^" + EpDays;
		InputStr += "^" + EpIsKeyStep;
		InputStr += "^" + EpIsOperDay;
		InputStr += "^" + EpIsFirstDay;
		InputStr += "^" + EpIsActive;
		InputStr += "^" ;
		InputStr += "^" ;
		InputStr += "^" + userID;	
		InputStr += "^" ;
		
		var data = $.cm({ClassName:"DHCMA.CPW.BT.PathFormEp",MethodName:"Update",
				"aInputStr":InputStr,
				"aSeparete":"^"
		},false);
		
		if(parseInt(data)<0){
			$.messager.alert("提示","失败！");
		}else{			
			//重新加载数据  
			obj.epRefresh();
			obj.dictDlg.close();
		}
	};
	//验证数值
	obj.numReg = function(numStr){
		var reg = /^[0-9]+(.[0-9]{0,2})?$/;//正则表达式 最多两位的正实数
		if (!reg.test(numStr)) {
			return false;
		}else{
			return true;
		}
	}
	//按钮处理事件
	obj.saveEpItemToSrv=function(){
		var userID = session['DHCMA.USERID'];
		
		var Parref = obj.selVerEpID;		
		var ID = $("#hiID").val();
		var ItemDesc = $("#txtItemDesc").val();
		var ItemCatDr = Common_GetValue("cboItemCatDr");
		var ItemIndNo  = $("#txtItemIndNo").val();
		var ItemIsOption = Common_GetValue("chkItemIsOption")?"1":"0";  //itmValue = $this.checkbox('getValue');
		var ItemIsActive = Common_GetValue("chkItemIsActive")?"1":"0";
		var ExeDesc   = $("#txtExeDesc").val();
		var errinfo = "";
		if (!ItemCatDr) {
			errinfo = errinfo + "项目分类为空!<br>";
		}
		if (!ItemDesc) {
			errinfo = errinfo + "项目描述为空!<br>";
		}
		//注意这个顺序号判断是应测试加的,修改的话别忘了改layout里面的内容
		if (!ItemIndNo) {
			errinfo = errinfo + "顺序号为空!<br>";
		}
		if (""!=ItemIndNo&&!obj.numReg(ItemIndNo)) {
			errinfo = errinfo + "顺序号只能为数值!<br>";
		}
		
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		
		var InputStr = Parref+"^"+ID;
		InputStr += "^" + ItemDesc;
		InputStr += "^" + ItemCatDr;
		InputStr += "^" + ItemIndNo;
		InputStr += "^" + ItemIsOption;
		InputStr += "^" + ItemIsActive;
		InputStr += "^" ;
		InputStr += "^" ;
		InputStr += "^" + userID;	
		InputStr += "^" ;
		InputStr += "^" + ExeDesc;
		
		var data = $.cm({ClassName:"DHCMA.CPW.BT.PathFormItem",MethodName:"Update",
				"aInputStr":InputStr,
				"aSeparete":"^"
		},false);
		
		if(parseInt(data)<0){
			$.messager.alert("提示","失败！");
		}else{			
			//重新加载数据  
			obj.refreshGridHl();
			obj.refreshGridYz();
			obj.refreshGridZl();
			obj.itemDlg.close();
			$("#addIconMrgl,#addIconMrgh,#addIconMrgz,#syncIconMrgz").linkbutton("enable");	
			$("#editIconMrgl,#editIconMrgh,#editIconMrgz").linkbutton("disable");	
			$("#delIconMrgl,#delIconMrgh,#delIconMrgz").linkbutton("disable");
			$.messager.alert("提示","成功！");
		}
	};
	//删除按钮处理事件
	obj.delHandler= function(){
		//id,code,desc
		
	};
	//显示路径信息
	obj.pathInfoTitle = function(verID){
		if (verID!=""){
			//取表单对象
			var objPathForm = $cm({ClassName:"DHCMA.CPW.BT.PathForm",MethodName:"GetObjById",aId:verID},false);
			//console.dir(objPathForm); 
			//$("#pathMastID").val(objPathForm.FormPathDr);
			$("#ckfy").text(objPathForm.FormCost);
			$("#ckts").text(objPathForm.FormDays);
			if (objPathForm.FormPathDr!=""){
				var objPathMast = $cm({ClassName:"DHCMA.CPW.BT.PathMast",MethodName:"GetObjById",aId:objPathForm.FormPathDr},false);
				$("#pathDesc").text(objPathMast.BTDesc);
				//准入数据
				$cm({
					ClassName:"DHCMA.CPW.BTS.PathAdmitSrv",
					QueryName:"QryPathAdmit",
					aBTPathDr:objPathForm.FormPathDr,
					ResultSetType:"array",
					page:1,    //可选项，页码，默认1
					rows:200    //可选项，获取多少条数据，默认50
				},function(rs){
					var diagCode ="",diagDesc="",operCode="",operDesc="";						
					for (var i=0;i<rs.length;i++) {
						var tmpObj = rs[i];
						if (tmpObj.BTICD10!="") {
							if (diagCode=="") {
								diagCode = tmpObj.BTICD10;
							} else {
								diagCode = diagCode+","+tmpObj.BTICD10;
							}
						}
						if (tmpObj.BTICDKeys!="") {
							if (diagDesc=="") {
								diagDesc = tmpObj.BTICDKeys;
							} else {
								diagDesc = diagDesc+","+tmpObj.BTICDKeys;
							}
						}
						if (tmpObj.BTOperICD!="") {
							if(operCode=="") {
								operCode = tmpObj.BTOperICD;
							} else {
								operCode = operCode+","+tmpObj.BTOperICD;
							}
						}
						if (tmpObj.BTOperKeys!="") {
							if (operDesc=="") {
								operDesc = tmpObj.BTOperKeys;
							} else {
								operDesc = operDesc+","+tmpObj.BTOperKeys;
							}
						}
					}
					$("#pathDiagDesc").text(diagDesc);
					$("#pathDiagCode").text(diagCode);		
					$("#pathOperDesc").text(operDesc);
					$("#pathOperCode").text(operCode);						
				});
			}
		}
	};
	//诊疗选择
	obj.gridZl_onSelect = function (){
		if ((obj.CurrForm.IsActive!=0)&&(obj.CurrForm.IsOpen!=1)){
			var rowData = obj.gridZl.getSelected();
			if($("#editIconMrgl").hasClass("l-btn-disabled")) obj.RecRowID="";
			if (rowData["ID"] == obj.RecRowID) {
				obj.RecRowID="";
				$("#addIconMrgl").linkbutton("enable");
				$("#editIconMrgl").linkbutton("disable");
				$("#delIconMrgl").linkbutton("disable");
				obj.gridZl.clearSelections();
			}
			else {
				obj.RecRowID = rowData["ID"];
				$("#addIconMrgl").linkbutton("disable");
				$("#editIconMrgl").linkbutton("enable");
				$("#delIconMrgl").linkbutton("enable");
			}
		}else{
			return;
		}
	}
	
	//护理选择
	obj.gridHl_onSelect = function (){
		if ((obj.CurrForm.IsActive!=0)&&(obj.CurrForm.IsOpen!=1)){
			var rowData = obj.gridHl.getSelected();
			if($("#editIconMrgh").hasClass("l-btn-disabled")) obj.RecRowID="";
			if (rowData["ID"] == obj.RecRowID) {
				obj.RecRowID="";
				$("#addIconMrgh").linkbutton("enable");
				$("#editIconMrgh").linkbutton("disable");
				$("#delIconMrgh").linkbutton("disable");
				obj.gridHl.clearSelections();
			}
			else {
				obj.RecRowID = rowData["ID"];
				$("#addIconMrgh").linkbutton("disable");
				$("#editIconMrgh").linkbutton("enable");
				$("#delIconMrgh").linkbutton("enable");
			}
		}else{
			return;
		}
	}
	
	//医嘱选择
	obj.gridYz_onSelect = function (){
		if ((obj.CurrForm.IsActive!=0)&&(obj.CurrForm.IsOpen!=1)){
			var rowData = obj.gridYz.getSelected();
			if($("#editIconMrgz").hasClass("l-btn-disabled")) obj.RecRowID="";
			if (rowData["ID"] == obj.RecRowID) {
				obj.RecRowID="";
				$("#addIconMrgz").linkbutton("enable");
				$("#editIconMrgz").linkbutton("disable");
				$("#delIconMrgz").linkbutton("disable");
				obj.gridYz.clearSelections();
			}
			else {
				obj.RecRowID = rowData["ID"];
				$("#addIconMrgz").linkbutton("disable");
				$("#editIconMrgz").linkbutton("enable");
				$("#delIconMrgz").linkbutton("enable");
			}
		}else{
			return;
		}
	}
	
	obj.refreshGridZl = function(){
		var tab = $('#tabs').tabs('getSelected');
		var index = $('#tabs').tabs('getTabIndex',tab);
		
		if((obj.gridZl==undefined)||(obj.gridZl==null))
		{
			//主要诊疗工作
			obj.gridZl = $HUI.datagrid("#gridZl",{
				url:$URL,
				singleSelect: true,
				queryParams:{
					ClassName:"DHCMA.CPW.BTS.PathFormEpSrv",
					QueryName:"QryPathFormEpItem",
					aPathFormEpDr:obj.selVerEpID,
					aDicCode:"A"
				},		
				columns:[[
					/* {field:'ID',width:'80',title:'操作',
						formatter:function(value,row,index){						
							// /csp/websys.csp?TE onclick='openRepWin(\""+value+"\")' '../images/websys/edit.gif'
							return "&nbsp;&nbsp;<a href='#' text=\""+value+"\" class='itemSDel' title='删除项目'>\
					<img src='../scripts/DHCMA/img/cancel.png' border=0/>\
					</a>&nbsp;&nbsp;<a href='#' class='itemSEdit' text=\""+value+"\" title='编辑项目'>\
					<img src='../scripts/DHCMA/img/pencil.png' border=0/>\
					</a>&nbsp;&nbsp;";
						}
					}, */
					{field:'ItemIndNo',width:'50',title:'顺序号'},
					{field:'ItemDesc',width:'380',title:'描述'},
					{field:'ItemIsOptionD',width:'70',title:'是否可选'},
					{field:'ExeDesc',width:'100',title:'执行提示'}				
				]],onSelect:function(rindex,rowData){
					if (rindex>-1) {
						obj.gridZl_onSelect();
					}
				},
				onLoadSuccess:function(data){
					if (data.total == 0) {
						addDivToGrid("gridZl")
					}
					//链接选中方式
					$('#gridZl-tool .itemSDel').unbind('click').on('click', function (e) {
						var row = $('#gridZl').datagrid("getSelected");
						if(row != null){//添加删除提示 by WJF 2018-10-24:13:27
							$.messager.confirm("确认","确定删除?",function(r){	
								if(r){
									var aID = row["ID"];
									var rstData = $cm({ClassName:"DHCMA.CPW.BT.PathFormItem",MethodName:"DeleteById",aId:aID},false);
									if(parseInt(rstData)<0){
										$.messager.alert("提示","失败！");
									}else{			
										//重新加载数据  
										$.messager.alert("提示","删除成功！");
										obj.refreshGridZl();
										obj.gridZl_onSelect();
									}   
								}
							});
						}else{
							$.messager.alert("提示","请选择一条数据！");
							return;
						}	
					});
					//链接选中方式
					$('#gridZl-tool .itemSEdit').on('click', function (e) {
						var row = $('#gridZl').datagrid("getSelected");
						if(row==null){ //by wjf
							$.messager.alert("提示","请选择一条数据");
							return;
						} 
						var aID = row["ID"];
						obj.openEpItemWin(aID);
					});
				},
				onDblClickRow:function(rowIndex, rowData){
					obj.ItemRowData = rowData;
					$("#itemEMRDlg").show();
					obj.itemEMRDlg = $HUI.dialog("#itemEMRDlg",{
						iconCls:'icon-save',
						title:"关联病历模板ID:"+rowData.ItemDesc,
						resizable:true,
						modal:true,
						onOpen:function(){
							obj.refreshGridMR();
						},		
						onBeforeOpen:function(){
							obj.editIndex=undefined;
						}
						
					});
				},
				pagination:true,
				pageSize:10,
				pageList:[10,20,50,100,200],
				fit:true
			});			
			
		}
		else
		{
			obj.gridZl.load({
				ClassName:"DHCMA.CPW.BTS.PathFormEpSrv",
				QueryName:"QryPathFormEpItem",
				aPathFormEpDr:obj.selVerEpID,
				aDicCode:"A"
			}); 
		}		
	};
	obj.refreshGridHl = function(){
		
		if((obj.gridHl==undefined)||(obj.gridHl==null))
		{
			//主要护理工作
			obj.gridHl = $HUI.datagrid("#gridHl",{
				url:$URL,
				singleSelect: true,
				queryParams:{
					ClassName:"DHCMA.CPW.BTS.PathFormEpSrv",
					QueryName:"QryPathFormEpItem",
					aPathFormEpDr:obj.selVerEpID,
					aDicCode:"C"
				},		
				columns:[[
					{field:'ItemIndNo',width:'50',title:'顺序号'},
					{field:'ItemDesc',width:'380',title:'描述'},
					{field:'ItemIsOptionD',width:'70',title:'是否可选'},
					{field:'ExeDesc',width:'100',title:'执行提示'}			
				]],
				onSelect:function(rindex,rowData){
					if (rindex>-1) {
						obj.gridHl_onSelect();
					}
				},
				onLoadSuccess:function(data){
					if (data.total == 0) {
						addDivToGrid("gridHl");
					}
					//链接选中方式
					$('#gridHl-tool .itemSDel').unbind('click').on('click', function (e) {
						var row = $('#gridHl').datagrid("getSelected");
						//$('#gridHl').datagrid("clearSelections");
						if(row!=null){//添加删除提示 by WJF 2018-10-24:13:27
							$.messager.confirm("确认","确定删除?",function(r){
								if(r){
									var aID = row["ID"];
									var rstData = $cm({ClassName:"DHCMA.CPW.BT.PathFormItem",MethodName:"DeleteById",aId:aID},false);
									if(parseInt(rstData)<0){
										$.messager.alert("提示","失败！");
									}else{			
										//重新加载数据  
										$.messager.alert("提示","删除成功！");
										obj.refreshGridHl();
										obj.gridHl_onSelect();
									}  
								}
							});
						}else{
							$.messager.alert("提示","请选择一条数据！");
							return false;
						}
					});
					//链接选中方式
					$('#gridHl-tool .itemSEdit').on('click', function (e) {
						var row = $('#gridHl').datagrid("getSelected");
						if(row==null){ //by wjf
							$.messager.alert("提示","请选择一条数据");
							return;
						} 
						var aID = row["ID"];
						obj.openEpItemWin(aID);
					});
				},
				pagination:true,
				pageSize:10,
				pageList:[10,20,50,100,200],
				fit:true
			});
			
		}
		else
		{
			obj.gridHl.load({
				ClassName:"DHCMA.CPW.BTS.PathFormEpSrv",
				QueryName:"QryPathFormEpItem",
				aPathFormEpDr:obj.selVerEpID,
				aDicCode:"C"
			}); 
		}
	};
	obj.refreshGridYz = function(){
		if((obj.gridYz==undefined)||(obj.gridYz==null))
		{
			//重点医嘱
			obj.gridYz = $HUI.datagrid("#gridYz",{
				url:$URL,
				singleSelect: true,
				remoteSort:"false",
				sortName:"ItemIndNo",
				sortOrder:"asc",
				queryParams:{
					ClassName:"DHCMA.CPW.BTS.PathFormEpSrv",
					QueryName:"QryPathFormEpItem",
					aPathFormEpDr:obj.selVerEpID,
					aDicCode:"B"
				},		
				columns:[[
					{field:'ItemIndNo',width:'50',title:'顺序号'},
					{field:'ItemDesc',width:'360',title:'描述'},
					{field:'ItemIsOptionD',width:'70',title:'是否可选'},
					{field:'ExeDesc',width:'100',title:'执行提示'},
					{field:'RelatedOrd',width:'100',title:'关联信息',formatter:function(v,r,i){
						var ret="";
						if (v.indexOf("项")!=-1){
							ret="<span style='margin-right:2px;padding:0 2px;background-color:#F16E57;color:#FFF;border-radius:3px;'>项</span>";
						}
						if (v.indexOf("套")!=-1){
							ret=ret+"<span style='margin-right:2px;padding:0 2px;background-color:#FD994A;color:#FFF;border-radius:3px;'>套</span>";
						}
						if (v.indexOf("协")!=-1){
							ret=ret+"<span style='margin-right:2px;padding:0 2px;background-color:#619ED1;color:#FFF;border-radius:3px;'>协</span>";
						}
						if (v.indexOf("自")!=-1){
							ret=ret+"<span style='margin-right:2px;padding:0 2px;background-color:#7DB561;color:#FFF;border-radius:3px;'>自</span>";
						}
						return ret;	
					}}			
				]],
				onSelect:function(rindex,rowData){
					if (rindex>-1) {
						obj.gridYz_onSelect();
					}
				},
				onLoadSuccess:function(data){
					if (data.total == 0) {
						addDivToGrid("gridYz")
					}
					//链接选中方式
					$('#gridYz-tool .itemSDel').unbind('click').on('click', function (e) {
						var row = $('#gridYz').datagrid("getSelected");
						//$('#gridYz').datagrid("clearSelections");
						if(row!=null){//添加删除提示 by WJF 2018-10-24:13:27
							$.messager.confirm("确认","确定删除?",function(r){	//添加删除提示 by WJF 2018-10-24:13:27
								if(r){
									var aID = row["ID"];
									var rstData = $cm({ClassName:"DHCMA.CPW.BT.PathFormItem",MethodName:"DeleteById",aId:aID},false);
									if(parseInt(rstData)<0){
										$.messager.alert("提示","失败！");
									}else{			
										//重新加载数据  
										$.messager.alert("提示","删除成功！");
										obj.refreshGridYz();
										obj.gridYz_onSelect();
									} 
								}	
							});
						}else{
							$.messager.alert("提示","请选择一条数据！");
							return false;
						}
					});
					//链接选中方式
					$('#gridYz-tool .itemSEdit').on('click', function (e) {
						var row = $('#gridYz').datagrid("getSelected");
						if(row==null){ //by wjf
							$.messager.alert("提示","请选择一条数据");
							return;
						} 
						var aID = row["ID"];
						obj.openEpItemWin(aID);
					});
					$('#gridYz-tool .itemSync').on('click', function (e) {
						var rstData = $cm({ClassName:"DHCMA.CPW.BTS.PathFormEpSrv",MethodName:"SyncOrdByItmDesc",aFormEpID:obj.selVerEpID},false);
						if(parseInt(rstData)==-2){
							$.messager.popover({msg: '最后一个阶段的医嘱无法进行同步关联医嘱操作！',type:'info'});
						}else if(parseInt(rstData)<=0){
							$.messager.popover({msg: '操作失败！',type:'error'});
						}else{
							$.messager.popover({msg: '操作成功！',type:'success'});
						} 
					});
				},
				onDblClickRow:function(rowIndex, rowData){
					obj.ItemRowData = rowData;
					var strUrl = "./dhcma.cpw.bt.itemord.csp?1=1" + 
							"&ParamID=" + obj.ItemRowData.ID + "&ParamDesc=" + obj.ItemRowData.ItemDesc;
					 websys_showModal({
						url:strUrl,
						title:'项目关联医嘱',
						iconCls:'icon-w-edit',  
						onClose:function(){obj.gridYz.load()},
						originWindow:window,
						width:1300,
						height:600
					});
				},
				rowStyler: function(index,row){
					if (parseInt(row["IsOrd"])>0){
						return 'color:#509DE1;'; 
					}else{
						return 'color:#000000;'; 
					}
				},
				pagination:true,
				pageSize:10,
				pageList:[10,20,50,100,200],
				fit:true
			});
			
		}
		else
		{
			obj.gridYz.load({
				ClassName:"DHCMA.CPW.BTS.PathFormEpSrv",
				QueryName:"QryPathFormEpItem",
				aPathFormEpDr:obj.selVerEpID,
				aDicCode:"B"
			}); 
		}
	};
	epEdit=function (aID){
		obj.openEpWin(aID);
	}
	epDelete=function (aID){
		$.messager.confirm("确认","确定删除?",function(r){
			if(r == true){
			var rstData = $cm({ClassName:"DHCMA.CPW.BT.PathFormEp",MethodName:"DeleteById",aId:aID},false);
			obj.epRefresh();
			}
		});
	}
	obj.epRefresh = function(){	
		$cm({
			ClassName:"DHCMA.CPW.BTS.PathFormEpSrv",
			QueryName:"QryPathFormEp",
			aPathFormDr:obj.selVerID,
			ResultSetType:"array",
			page:1,    //可选项，页码，默认1
			rows:200    //可选项，获取多少条数据，默认50
		},function(rs){
			//console.dir(rs); 
			$("#ulEp").empty();
			var str="";
			str += "<li class='treeview'>";
			str +="<ul id='ulEpMX' class='treeview-menu'>"
			for (var i=0;i<rs.length-1;i++){//重新按顺序号排列数组
				for (var j=0;j<rs.length-1-i;j++){
					if (rs[j].EpIndNo > rs[j + 1].EpIndNo) {
        				var temp = rs[j];
        				rs[j] = rs[j + 1];
        				rs[j + 1] = temp;
        			}
				}
			}
			for (var i=0;i<rs.length;i++){
				var tmpObj = rs[i];
				str += "<li id='epli"+tmpObj.ID+"' text='"+tmpObj.ID+"' class='treeview' style='text-align: center;'><a id='LocpID' href='#' >"+ tmpObj.EpDesc+"</a></li>";
			}
			if ((obj.CurrForm.IsActive!=0)&&(obj.CurrForm.IsOpen!=1)){
				str += "<li class='treeview' text='' style='text-align: center;'><a>添加阶段</a></li>";	
			}
			str += "</ul></li>";
			$("#ulEp").append(str);
			$("#ulEpMX > li:not(':last')").each(function(){
				//alert($(this).attr("text"));
				if ((obj.CurrForm.IsActive!=0)&&(obj.CurrForm.IsOpen!=1)){
					$(this).popover({trigger:'hover',offsetLeft:2,arrow:false,style:'myma',placement:"right",content:"<a style='cursor:pointer;' onclick='epEdit(\""+$(this).attr("text")+"\");' class='icon icon-edit'>&nbsp;&nbsp;&nbsp;&nbsp;</a>&nbsp;&nbsp;&nbsp;&nbsp;<a style='cursor:pointer;' onclick='epDelete(\""+$(this).attr("text")+"\");' class='icon icon-no'>&nbsp;&nbsp;&nbsp;&nbsp;</a>"});
		  		}
		    });
			
			$('#ulEpMX > li').click(function (e) {
				e.preventDefault();
				$('#ulEpMX > li').removeClass('active');
				$(this).addClass("active");					
				obj.selVerEpID = $(this).attr("text");
				if(obj.selVerEpID!="")
				{
					obj.refreshGridHl();
					obj.refreshGridYz();
					obj.refreshGridZl();
				}				
			});
			//默认选择第一条科室
			$('#ulEpMX li:first-child').click();
			//$('#ulEpMX li:first-child').addClass("active");	
			$("#ulEpMX > li:last-child").click(function(e){
				if ((obj.CurrForm.IsActive!=0)&&(obj.CurrForm.IsOpen!=1)){
					obj.openEpWin("");	//增加阶段
				}
			});
		});
		
	};
	//删除按钮处理事件
	obj.delHandler= function(){
		if(obj.editIndex ==null){return;}
		if (obj.modifyBeforeRow.ID == null) { return; }
		
		if (obj.modifyBeforeRow.ID){			
			$.messager.confirm("确认","确定删除?",function(r){
				if(r){					
					$.cm({ClassName:'DHCMA.CPW.BT.PathFormMR',MethodName:'DeleteById','aId':obj.modifyBeforeRow.ID},function(data){
						//debugger;
						if(parseInt(data)<0){
							$.messager.alert("提示","失败！");  //data.msg
						}else{							
							//重新加载datagrid的数据  
							obj.emrList.load({
								ClassName:"DHCMA.CPW.BTS.PathFormEpSrv",
								QueryName:"QryPathFormEpItemMR",
								aPathFormEpItemDr:obj.ItemRowData.ID 
							}); 
							$("#addIcon").linkbutton("enable");
							$("#editIcon").linkbutton("disable");
							$("#saveIcon").linkbutton("disable");
							$("#delIcon").linkbutton("disable");
							obj.editIndex = null;
						}
					});
				}
			});
		}
	};
	//删除按钮处理事件
	obj.delFormVerHandler= function(){		
		if (obj.selVerID){			
			var selNode=$('#treeType').tree('getSelected');
			if(selNode)
			{
				$.messager.confirm("确认","确定作废?",function(r){
					if(r){					
						$.cm({ClassName:'DHCMA.CPW.BTS.PathFormSrv',MethodName:'ActiveFalse','aFormVerID':obj.selVerID},function(data){
							if(parseInt(data)<0){
								$.messager.alert("提示","作废失败！");  //data.msg
							}else{							
								var par = $('#treeType').tree('getParent',selNode.target);
								$('#treeType').tree('reload', par.target);

							}
						});
					}
				});
			}
		}
	};
	//按钮处理事件
	obj.pubFormVerHandler= function(){		
		if (obj.selVerID){			
			var selNode=$('#treeType').tree('getSelected');
			if(selNode)
			{
				$.messager.confirm("确认","确定发布，发布之后不可以修改?",function(r){
					if(r){					
						$.cm({ClassName:'DHCMA.CPW.BTS.PathFormSrv',MethodName:'PathFormPub','aFormVerID':obj.selVerID,'aUserID':session['DHCMA.USERID']},function(data){
							if(parseInt(data)<0){
								if(parseInt(data)==-2) {
									$.messager.alert("提示","应先作废已发布的版本！");
									return;
								}
								$.messager.alert("提示","发布失败！");  //data.msg
							}else{							
								var par = $('#treeType').tree('getParent',selNode.target);
								$('#treeType').tree('reload',par.target);

							}
						});
					}
				});
			}
		}
	};
	obj.CoypFormVerHandler = function(){
		if (obj.selVerID){
			var selNode=$('#treeType').tree('getSelected');
			if(selNode)
			{
				$.messager.prompt("提示", "请输入新路径名称：", function (name) {
					if (name) {
						$.cm({ClassName:'DHCMA.CPW.BTS.PathFormSrv',MethodName:'CopyFormAsNew','aPathFormID':obj.selVerID,'aNewName':name,'aUserID':session['DHCMA.USERID']},function(ret){
							if(parseInt(ret)<0){
								if(parseInt(data)==-2) {
									$.messager.alert("提示","路径名称重复");
									return;
								}
								$.messager.alert("提示","复制失败！errCode="+ret);
							}else{							
								var par = $('#treeType').tree('getParent',selNode.target);
								var parPar=$('#treeType').tree('getParent',par.target);
								$('#treeType').tree('reload',parPar.target);
							}
						});
					} else {
					}
				});
			}
		}
	}

	//事件绑定
	obj.LoadEvents = function(arguments){	
		obj.CurrTab="",obj.CurrAdmType=""
		$HUI.tabs("#cpwTypeTab",{
			onSelect:function(title,index){
				$("#workS").show();
				if(title=="住院路径"){
					obj.CurrTab="InCPW";					
					obj.CurrAdmType="I";
				}else if(title=="门诊路径"){
					obj.CurrTab="OutCPW";					
					obj.CurrAdmType="O";
				}else {}
				if ($("#treeType").length>0) {
					$("#treeType").tree('loadData', []);
				}
				$("#InCPW").empty();
				$("#OutCPW").empty();
				$("#"+obj.CurrTab).append('<ul id="treeType" class="hisui-tree" data-options="lines:true"></ul>');
				obj.LoadPathTree(obj.CurrAdmType);
								
				$('#treeType').tree({
					onClick:function(node){	
						obj.treeClick(node);
					},
					onSelect:function(node){
						// obj.treeClick(node); 
					}
					,onBeforeExpand:function(node,param){
						var idVal = node.id;
						
						if(idVal.indexOf("Path")>-1)
						{
							var rs=$cm({
							ClassName:"DHCMA.CPW.BTS.PathFormSrv",
							QueryName:"QryLocPathVer",
							argNodeID:node.id,
							argLocID:"",
							argHospID:obj.cboHospValue,
							ResultSetType:"array", 
							page:1,    
							rows:9999
							},false);
							if(rs==""){
								$.messager.alert("提示","当前路径尚未有版本,请先新建一个版本！");
								return false;
							}
						}
						//参数重置
					}
					,onExpand:function(node)
					{
						obj.refreshNode(node);			
					}
					,onCollapse:function(node)
					{
						//node.state = "closed";
					}
					,onContextMenu: function(e, node){
						e.preventDefault();
						// select the node
						$('#treeType').tree('select', node.target);
						// display context menu
						var idVal = node.id;
						if(idVal.indexOf("Ver")>-1)
						{
							$("#btnPubForm").css("color","#000000");
							$("#btnPubForm").css("cursor","pointer");
							$("#btnDelForm").css("color","#000000");
							$("#btnDelForm").css("cursor","pointer");
							$("#btnPubForm").attr("disable","0")
							$("#btnDelForm").attr("disable","0")
							if(node.text.indexOf("正使用")>-1) {
								$("#btnPubForm").css("color","#DDDDDD");
								$("#btnPubForm").css("cursor","not-allowed");
								$("#btnPubForm").attr("disable","1");
							}
							if(node.text.indexOf("作废")>-1) {
								$("#btnDelForm").css("color","#DDDDDD");
								$("#btnDelForm").css("cursor","not-allowed");
								$("#btnDelForm").attr("disable","1");
							}
							//非管理员权限不能发布、作废
							if(obj.IsAdmin<1) {
								$("#btnPubForm").css("color","#DDDDDD");
								$("#btnPubForm").css("cursor","not-allowed");
								$("#btnPubForm").attr("disable","1");
								$("#btnDelForm").css("color","#DDDDDD");
								$("#btnDelForm").css("cursor","not-allowed");
								$("#btnDelForm").attr("disable","1");
							}
							$('#mm').menu('show', {
								left: e.pageX,
								top: e.pageY
							});
						}
					}
				});
			}
		});
		$(".btnEpItemAdd").on('click',function(){
			//编辑			
			if(obj.selVerEpID=="")
			{
				$.messager.alert("提示","请先选中需要增加项目的路径阶段！");
			}
			else
			{
				obj.openEpItemWin("");
			}
		});
		$("#btnDelForm").on('click',function(){
			//作废			
			if(obj.selVerID=="")
			{
				$.messager.alert("提示","请先选中需要作废的路径版本！");
			}
			else
			{
				if($("#btnDelForm").attr("disable") == "1") return;
				obj.delFormVerHandler();
			}
		});
		$("#btnPubForm").on('click',function(){
			//	
			if(obj.selVerID=="")
			{
				$.messager.alert("提示","请先选中需要发布的路径版本！");
			}
			else
			{
				if($("#btnPubForm").attr("disable") == "1") return;
				obj.pubFormVerHandler();
			}
		});
		$("#btnCopyPath").on('click',function(){
			//	
			if(obj.selVerID=="")
			{
				$.messager.alert("提示","请先选中需要复制的路径版本！");
			}
			else
			{
				obj.CoypFormVerHandler();
			}
		});
		$("#btnExportForm").on('click',function(){
			
			var verNode=$('#treeType').tree('getSelected');
			var formNode = $('#treeType').tree('getParent',verNode.target);
			var FormName=formNode.text+"("+verNode.text+")";
			var FormID=verNode.id.split("-")[0];
			
			ExportForm(FormID,FormName)
		
		});
		$("#btnExportOrd").on('click',function(){
			var verNode=$('#treeType').tree('getSelected');
			var formNode = $('#treeType').tree('getParent',verNode.target);
			var FormName=formNode.text+"("+verNode.text+")";
			var FormID=formNode.id.split("-")[0];
			
		});
		$("#tmp").on('click',function(){
			var rtn = $cm({
				dataType:'text',
				ResultSetType:"Excel",
				ExcelName:"excelname", //默认DHCCExcel
				ClassName:"DHCHAI.DPS.PAAdmSrv",
				QueryName:"QryAdm",
				aIntputs:"1|2|3|4^1^2017-08-01^2017-08-31^^^^^"
			},false);
			location.href = rtn;
		});	
		$("#addIcon").on('click',function(){
			// 添加一行
			if (obj.endEditing()) {
				//$("#dg").datagrid("appendRow");
				$("#emrList").datagrid("appendRow", {
					ID:"",
					MRTypeID: "",
					MRTypeDrCode: "",
					MRTypeDrDesc: "",
					MRTempID: "",
					MRIsActive:"1",
					MRIsActiveD:"是"
				});
				obj.editIndex = $("#emrList").datagrid("getRows").length - 1;
				$("#emrList").datagrid("selectRow", obj.editIndex).datagrid("beginEdit", obj.editIndex);
				$("#addIcon").linkbutton("disable");
				$("#editIcon").linkbutton("disable");
				$("#saveIcon").linkbutton("enable");
				$("#delIcon").linkbutton("enable");
			}
		});
		$("#editIcon").on('click',function(){
			if (obj.editIndex == undefined){
				$.messager.alert("提示","无编辑行！");
				return;
			}
			obj.endEditing();
		});
		$("#saveIcon").on('click',function(){
			if (obj.editIndex == undefined){
				$.messager.alert("提示","无编辑行！");
				return;
			}
			obj.endEditing();
		});	
		$("#delIcon").on('click',function(){	
			if(obj.editIndex ==null){
				$.messager.alert("提示","请先选中行，再执行删除操作！");
				return;
			}
			if (obj.modifyBeforeRow.ID == null) {
				$.messager.alert("提示","请先选中行，再执行删除操作！");
				return; 
			}	
			obj.delHandler();
		});
		
		//准入提示信息-增加按钮
		$("#addIconMrg").on('click',function(){
			// 如果有编辑行，直接退出
			if (obj.gridPathAdmitEditIndex>-1){
				$.messager.alert("提示","请先保存当前编辑行！");
				return;
			}
			
			$("#gridPathAdmit").datagrid("appendRow", {
				ID:"",
				BTPathDr: $("#pathMastID").val(),
				BTTypeDr: "",
				BTTypeDrDesc: "",
				BTICD10: "",
				BTICDKeys: "",
				BTOperICD:"",
				BTOperKeys:"",
				BTIsICDAcc:"否",
				BTIsOperAcc:"否",
				BTIsActive:"是"
			});
			var rowIndex=$("#gridPathAdmit").datagrid("getRows").length - 1;
			$('#gridPathAdmit').datagrid('selectRow', rowIndex).datagrid('beginEdit', rowIndex);
		});
		//准入提示信息-取消按钮
		$("#cancelIconMrg").on('click',function(){
			if (obj.gridPathAdmitEditIndex>-1){
				$('#gridPathAdmit').datagrid("cancelEdit", obj.gridPathAdmitEditIndex);  //结束行编辑
				obj.gridPathAdmit.load({
								ClassName:"DHCMA.CPW.BTS.PathAdmitSrv",
								QueryName:"QryPathAdmit",
								aBTPathDr:$("#pathMastID").val() 
							}); 
			} else {
				$.messager.alert("提示","无编辑行！");
				obj.gridPathAdmit.load({
								ClassName:"DHCMA.CPW.BTS.PathAdmitSrv",
								QueryName:"QryPathAdmit",
								aBTPathDr:$("#pathMastID").val() 
							}); 
			}
		});
		//准入提示信息-保存按钮
		$("#editIconMrg").on('click',function(){
			if (obj.gridPathAdmitEditIndex>-1){
				var rowIndex = obj.gridPathAdmitEditIndex;
				$('#gridPathAdmit').datagrid("endEdit", obj.gridPathAdmitEditIndex);  //结束行编辑
				var rowData  = $('#gridPathAdmit').datagrid('getRows')[rowIndex];  //获取编辑行数据
				var rowID    = obj.savegridPathAdmitRow(rowData);  //保存编辑行数据
				$('#gridPathAdmit').datagrid('reload');  //重新加载Grid数据
			} else {
				$.messager.alert("提示","无编辑行！");
			}
		});
		//准入提示信息-删除按钮
		$("#delIconMrg").on('click',function(){
			obj.deletegridPathAdmitRow();
		});
		
		//方剂证型维护-添加按钮
     	$('#btnPathFormSympAdd').on('click', function(){
			obj.PathFormSympEdit();
     	});
		//方剂证型维护-编辑按钮
		$('#btnPathFormSympEdit').on('click', function(){
	     	var rd=obj.gridPathFormSymp.getSelected()
	     	if (rd){
		     	obj.PathFormSympEdit(rd);
		    }
     	});
		//方剂证型维护-删除按钮
		$('#btnPathFormSympDelete').on('click', function(){
	     	obj.btnPathFormSympDelete_click();
     	});
		//方剂证型维护-保存按钮
		$('#btnPathFormSympSave').on('click', function(){
	     	obj.btnPathFormSympSave_click();
     	});
		//方剂证型维护-关闭按钮
		$('#btnPathFormSympClose').on('click', function(){
	     	$HUI.dialog('#winPathFormSympEdit').close();
     	});
		
		$("#btnInitVer").on('click',function(){
			obj.saveVerToSrv(obj.selPath);
		});
		
		obj.refreshNode = function(node)
		{
			//加载子节点数据				
			var subNodes = [];
			$(node.target)
			.next().children().children("div.tree-node").each(function(){   
				var tmp = $('#treeType').tree('getNode',this);
				subNodes.push(tmp);
			});
			//$('#treeType').tree('remove',cArr[i].target);
			for(var i=0;i<subNodes.length;i++)
			{
				$('#treeType').tree('remove',subNodes[i].target);
			}
			$cm({
				ClassName:"DHCMA.CPW.BTS.PathFormSrv",
				QueryName:"QryLocPathVer",
				argNodeID:node.id,
				argLocID:"",
				argHospID:obj.cboHospValue,
				ResultSetType:"array", 
				page:1,    
				rows:9999
			},function(rs){   
				$('#treeType').tree('append', {
						parent: node.target,
						data: rs
				});
				$('.hisui-splitbutton').splitbutton({ 
				}); 
			});	
		};
		obj.DisplayPathFromWin = function (PathFormID) {	 
			var strUrl = "./dhcma.cpw.bt.pathformmrg.csp?1=1" + 
							"&PathFormID=" + PathFormID ;
			 websys_showModal({
				url:strUrl,
				title:'路径信息维护',
				iconCls:'icon-w-edit',  
				//onBeforeClose:function(){alert('close')},
				dataRow:{PathFormID:PathFormID},   //？
				originWindow:window,
				width:940,
				height:500
			});
		};
		
		$("#btnPathEdit").on('click',function(){
			var txt = $('#btnPathEdit').text();
			if(txt =='新增版本')
			{
				obj.saveVerToSrv(obj.selPath);
			}
			else
			{
				//编辑
				
				if(obj.selVerID=="")
				{
					$.messager.alert("提示","请先选中需要修改的路径版本！");
				}
				else
				{
					obj.DisplayPathFromWin(obj.selVerID);
				}
			}
		});	
		
		$("#btnSaveInfo").on('click',function(){
			var Code = $('#txtPathCode').val();
			var Desc = $('#txtPathDesc').val();
			var BTTypeDr   =$('#cboTypeDr').combobox('getValue');
			var BTEntityDr = $('#cboEntityDr').combobox('getValue');
			var BTPCEntityDr = $('#cboPCEntityDr').combobox('getValue');
			var BTQCEntityDr = $('#cboQCEntityDr').combobox('getValue');
			var IsActive = $("#txtIsActive").switchbox('getValue')?1:0;
			var BTActDate ='';
			var BTActTime='';
			var BTActUserID="";
			if(session['DHCMA.USERID']) BTActUserID=session['DHCMA.USERID'];
			var errinfo = "";
			if (!Code) {
				errinfo = errinfo + "代码为空!<br>";
			}
			if (!Desc) {
				errinfo = errinfo + "名称为空!<br>";
			}	
			var IsCheck = $m({
				ClassName:"DHCMA.CPW.BT.PathMast",
				MethodName:"CheckPTCode",
				aCode:Code,
				aID:$("#pathMastID").val()
			},false);
			if(IsCheck>=1) {
				errinfo = errinfo + "代码与列表中现有项目重复，请检查修改!<br>";
			}
			if (errinfo) {
				$.messager.alert("错误提示", errinfo, 'info');
				return;
			}
			
			var MastID=$("#pathMastID").val();
			var inputStr = MastID;
			inputStr = inputStr + CHR_1 + Code;
			inputStr = inputStr + CHR_1 + Desc;
			inputStr = inputStr + CHR_1 + BTTypeDr;
			inputStr = inputStr + CHR_1 + BTEntityDr;
			inputStr = inputStr + CHR_1 + BTPCEntityDr;
			inputStr = inputStr + CHR_1 + BTQCEntityDr;
			inputStr = inputStr + CHR_1 + IsActive;
			inputStr = inputStr + CHR_1 + BTActDate;
			inputStr = inputStr + CHR_1 + BTActTime;
			inputStr = inputStr + CHR_1 + BTActUserID;
			inputStr = inputStr + CHR_1 + obj.CurrAdmType;
			
			var flg = $m({
				ClassName:"DHCMA.CPW.BT.PathMast",
				MethodName:"Update",
				aInputStr:inputStr,
				aSeparete:CHR_1
				},false);
				if (parseInt(flg) <= 0) {
					if (parseInt(flg) == 0) {
						$.messager.alert("错误提示", "参数错误!" , 'info');
					}else if (parseInt(flg) == -2) {
						$.messager.alert("错误提示", "数据重复!" , 'info');
					} else {
						$.messager.alert("错误提示", "更新数据错误!Error=" + flg, 'info');
					}
				}else {
					var flg = $m({
						ClassName:"DHCMA.CPW.BT.PathForm",
						MethodName:"UpdateCostDay",
						aId:obj.lastVerID,
						aCost:$("#txtFormCost").val(),
						aDay:$("#txtFormDays").val()
						},false);
					$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
					//window.location.reload();
					obj.DisplayPathFromWin.reload();
					obj.gridPathAdmit.reload();
				}
			});
			
			$('#btnEditNote').on('click', function(){
				var strUrl = "./dhcma.cpw.bt.docedit.csp?1=1" + "&FormID=" + obj.lastVerID;
					 websys_showModal({
						url:strUrl,
						title:'临床路径适用对象文档编辑',
						iconCls:'icon-w-edit',  
						closable:true,
						//onBeforeClose:function(){alert('close')},
						//dataRow:{EpisodeID:EpisodeID},   //？
						originWindow:window,
						width:600,
						height:500
					});
			});
			$('#btnPathSearch').on('click', function(){
				//清除数据
				obj.cboHospValue="";
				var data=$('#cboHosp').combobox('getData');
				for (var jnd=0;jnd<data.length;jnd++){
					$('#cboHosp').combobox('unselect',data[jnd]['OID']);
				}
				
				//根据登录信息赋值
				$('#cboHosp').combobox('select',session['DHCMA.HOSPID']);
				
				//非管理员权限不能选择院区
				if(tDHCMedMenuOper['admin']<0) $('#cboHosp').combobox('disable');
				
				$HUI.dialog('#winPathSearch').open();
			});
			$('#btnPathReload').on('click', function(){
				obj.cboHospValue=session['DHCMA.HOSPID'];
				obj.DescSearch=="";
				$('#treeType').tree({
					url:$URL+"?ClassName=DHCMA.CPW.BTS.PathFormSrv&QueryName=QryLocPathVer&argNodeID=-root&argLocID="+obj.LocID+"&argAdmType="+obj.CurrAdmType+"&argHospID="+obj.cboHospValue+"&argDesc="+""+"&argKeyWords="+""+"&ResultSetType=array"	
					,onLoadSuccess:function(node,data)
					{
					}
				});	
				$('#treeType').tree('reload');
			});
			$("body").layout();
			//$("#layoutId").layout("resize");
			//$.parser.parse($('#dictDlg').parent());
			$.parser.parse($("body"));
			//$("body").layout('collapse','west');
			$("#workS").show();
			$("#workP").hide();
			$("#workD").hide();
	};	
	obj.openEpWin = function(EpID){
		//$.parser.parse($('#dictDlg').parent());
		if(EpID!="")
		{
			var rstData = $cm({ClassName:"DHCMA.CPW.BT.PathFormEp",MethodName:"GetObjById",aId:EpID},false);
			$("#hID").val(EpID);
			$("#txtDesc").val(rstData.EpDesc);
			$("#txtDesc1").val(rstData.EpDesc2);
			$("#txtIndNo").val(rstData.EpIndNo);
			$("#txtEpDays").val(rstData.EpDays);
			$('#chkEpIsFirstDay').checkbox('setValue',rstData.EpIsFirstDay =="1"?true:false);
			$('#chkEpIsKeyStep').checkbox('setValue',rstData.EpIsKeyStep =="1"?true:false);
			$('#chkEpIsOperDay').checkbox('setValue',rstData.EpIsOperDay =="1"?true:false);
			$('#chkActive').checkbox('setValue',rstData.EpIsActive =="1"?true:false);
			$("#txtDesc,#txtDesc1,#txtIndNo,#txtEpDays").validatebox({required:true});

		}
		else
		{			
			$("#hID").val("");
			$("#txtDesc").val("");
			$("#txtDesc1").val("");
			$("#txtIndNo").val("");
			$("#txtEpDays").val("");
			
			//$("#chkEpIsKeyStep").checkbox('setValue',true);
			//$("#chkEpIsKeyStep").iCheck('check');
			$('#chkEpIsFirstDay').checkbox('setValue',false);
			$('#chkEpIsKeyStep').checkbox('setValue',false);
			$('#chkEpIsOperDay').checkbox('setValue',false);
			$('#chkActive').checkbox('setValue',true);
			$("#txtDesc,#txtDesc1,#txtIndNo,#txtEpDays").validatebox({required:true});
		}
		
		$("#dictDlg").show();
		obj.dictDlg = $HUI.dialog("#dictDlg",{
			iconCls:'icon-w-edit',
			title:"阶段维护",
			resizable:true,
			modal:true,
			buttons:[{
				text:'保存',
				handler:function(){
					//保存
					obj.saveEpToSrv();
					
				}
			},{
				text:'关闭',
				handler:function(){
					obj.dictDlg.close();
				}
			}]
		});
	};
	obj.openEpItemWin = function(EpItemID){
		var tab = $('#tabs').tabs('getSelected');
		var index = $('#tabs').tabs('getTabIndex',tab);
		var dicCode = "";
		if(index=="0")
		{
			dicCode="A";
		}
		else if(index=="1")
		{
			dicCode="C";
		}
		else if(index=="2")
		{
			dicCode="B";
		}
		//初始化赋值
		obj.cboItemCatDr = $HUI.combobox("#cboItemCatDr",{
			url:$URL+"?ClassName=DHCMA.CPW.BTS.PathItemCatSrv&QueryName=QryPathItemCatByD&aDicCode="+dicCode+"&ResultSetType=array",
			valueField:'BTID',
			textField:'BTDesc'
		});
		if(EpItemID!="")
		{
			var rstData = $cm({ClassName:"DHCMA.CPW.BT.PathFormItem",MethodName:"GetObjById",aId:EpItemID},false);
			$("#hiID").val(EpItemID);
			Common_SetValue("cboItemCatDr",rstData.ItemCatDr);
			$("#txtItemDesc").val(rstData.ItemDesc);
			$("#txtItemIndNo").val(rstData.ItemIndNo);
			$('#chkItemIsOption').checkbox('setValue',rstData.ItemIsOption =="1"?true:false);
			$('#chkItemIsActive').checkbox('setValue',rstData.ItemIsActive =="1"?true:false);
			$("#txtExeDesc").val(rstData.ExeDesc);
			setTimeout(function() {$('.hisui-validatebox').validatebox('validate');},100);
		}
		else
		{			
			$("#hiID").val("");
			Common_SetValue("cboItemCatDr","");
			$("#txtItemDesc").val("");
			$("#txtItemIndNo").val("");
			$('#chkItemIsOption').checkbox('setValue',false);
			$('#chkItemIsActive').checkbox('setValue',true);
			$("#txtExeDesc").val("");
		}
		$("#itemDlg").show();
		obj.itemDlg = $HUI.dialog("#itemDlg",{
			iconCls:'icon-w-edit',
			title:"阶段项目维护",
			resizable:true,
			modal:true,
			buttons:[{
				text:'保存',
				handler:function(){
					//保存
					obj.saveEpItemToSrv();					
				}
			},{
				text:'关闭',
				handler:function(){
					obj.itemDlg.close();
				}
			}]
		});
	};
	//提交后台保存
	obj.saveMRToSrv=function(){
		var Parref = obj.ItemRowData.ID;
		var ID = obj.modifyAfterRow.ID;
		//$.form.GetValue("txtDicCode")
		var MRTypeID = obj.modifyAfterRow.MRTypeID;
		var MRTempID  =obj.modifyAfterRow.MRTempID;
		var MRIsActive = obj.modifyAfterRow.MRIsActiveD;		
		MRIsActive = (MRIsActive =="是"?"1":"0");
		if(MRTypeID=="")
		{
			$.messager.alert("提示","病历类型不可以为空！");
			return false;
		}
		if(MRTempID=="")
		{
			$.messager.alert("提示","模板ID不可以为空！");
			return false;
		}
		var InputStr = Parref+"^"+ID;
		InputStr += "^" + MRTypeID;
		InputStr += "^" + MRTempID;
		InputStr += "^" + MRIsActive;
		InputStr += "^";
		InputStr += "^";
		InputStr += "^" + session['DHCMA.USERID'];
		
		//同步调用
		var data = $.cm({ClassName:"DHCMA.CPW.BT.PathFormMR",MethodName:"Update",
				"aInputStr":InputStr,
				"aSeparete":"^"
			},false);
		if(parseInt(data)<0){
			$.messager.alert("提示","失败！");
			return false;
		}else{			
			$('#emrList').datagrid('getRows')[obj.editIndex]['ID'] = Parref+"||"+data;
			$('#emrList').datagrid('refreshRow',obj.editIndex);
			$.messager.alert("提示","成功。", 'info');			
		}
		return true;
	};
	obj.endEditing=function(){
		if (obj.editIndex == undefined){return true;}
		if ($('#emrList').datagrid('validateRow', obj.editIndex)){	
			//列表中下拉框实现，修改后把回写
			var ed = $('#emrList').datagrid('getEditor', {index:obj.editIndex,field:'MRTypeID'});
			if(!ed) return true;
			var MRTypeIDDesc = $(ed.target).combobox('getText');
			$('#emrList').datagrid('getRows')[obj.editIndex]['MRTypeDrDesc'] = MRTypeIDDesc;
			$('#emrList').datagrid('endEdit', obj.editIndex);
			//保存后台数据
			obj.modifyAfterRow = $('#emrList').datagrid('getRows')[obj.editIndex];
			obj.saveMRToSrv();						
			obj.editIndex = null;
			$("#addIcon").linkbutton("enable");
			$("#editIcon").linkbutton("disable");
			$("#saveIcon").linkbutton("disable");
			$("#delIcon").linkbutton("disable");
			return true;
		} else {
			$.messager.alert("提示","病历类型不可以为空！");
			return false;
		}
	};
	
	obj.refreshGridMR = function(){
		if ((obj.CurrForm.IsActive!=0)&&(obj.CurrForm.IsOpen!=1)){
			$("#addIcon").linkbutton("enable");
			$("#editIcon").linkbutton("disable");
			$("#saveIcon").linkbutton("disable");
			$("#delIcon").linkbutton("disable");
		}else{
			$("#addIcon").linkbutton("disable");
			$("#editIcon").linkbutton("disable");
			$("#saveIcon").linkbutton("disable");
			$("#delIcon").linkbutton("disable");
			
		}
		if((obj.emrList==undefined)||(obj.emrList==null))
		{
			obj.btnAddMR=$HUI.linkbutton("#addIcon",{
				iconCls:'icon-add',
				plain:true,
				text:'新增'
			});
			obj.btnEditMR=$HUI.linkbutton("#editIcon",{
				iconCls:'icon-write-order',
				plain:true,
				text:'修改'
			});
			obj.btnSaveMR=$HUI.linkbutton("#saveIcon",{
				iconCls:'icon-save',
				plain:true,
				text:'保存'
			});
			obj.btnDelMR=$HUI.linkbutton("#delIcon",{
				iconCls:'icon-cancel',
				plain:true,
				text:'删除'
			});			
			//
			obj.emrList = $HUI.datagrid("#emrList",{
				url:$URL,
				queryParams:{
					ClassName:"DHCMA.CPW.BTS.PathFormEpSrv",
					QueryName:"QryPathFormEpItemMR",
					aPathFormEpItemDr:obj.ItemRowData.ID
				},
				onSelect:function(rowIndex,rowData){
					if (rowIndex>-1){
						if ((obj.CurrForm.IsActive!=0)&&(obj.CurrForm.IsOpen!=1)){
							
							$("#addIcon").linkbutton("disable");
							$("#editIcon").linkbutton("enable");
							$("#saveIcon").linkbutton("enable");
							$("#delIcon").linkbutton("enable");
						}else{
							
							$("#addIcon").linkbutton("disable");
							$("#editIcon").linkbutton("disable");
							$("#saveIcon").linkbutton("disable");
							$("#delIcon").linkbutton("disable");
						}
					}
				},
				onClickRow: function(rowIndex,rowData){
					if ((obj.CurrForm.IsActive!=0)&&(obj.CurrForm.IsOpen!=1)){
						$("#addIcon").linkbutton("disable");
						$("#editIcon").linkbutton("enable");
						$("#saveIcon").linkbutton("enable");
						$("#delIcon").linkbutton("enable");
						if (obj.editIndex!=rowIndex) {
							if (obj.endEditing()){
								$('#emrList').datagrid('selectRow', rowIndex)
										.datagrid('beginEdit', rowIndex);
								obj.editIndex = rowIndex;
								obj.modifyBeforeRow = $.extend({},$('#emrList').datagrid('getRows')[obj.editIndex]);
							} else {					
								$('#emrList').datagrid('selectRow', obj.editIndex);
								obj.editIndex = null;
							}
						}
					}else{
						$("#addIcon").linkbutton("disable");
						$("#editIcon").linkbutton("disable");
						$("#saveIcon").linkbutton("disable");
						$("#delIcon").linkbutton("disable");
						return;
					}
				},
				onBeforeSortColumn: function(){
					if ((obj.CurrForm.IsActive!=0)&&(obj.CurrForm.IsOpen!=1)){
						
						$("#addIcon").linkbutton("enable");
						$("#editIcon").linkbutton("disable");
						$("#saveIcon").linkbutton("disable");
						$("#delIcon").linkbutton("disable");
					}else{
						$("#addIcon").linkbutton("disable");
						$("#editIcon").linkbutton("disable");
						$("#saveIcon").linkbutton("disable");
						$("#delIcon").linkbutton("disable");
					}
					obj.editIndex == undefined
				},
				columns:[[			
					{field:'MRTypeID',title:'病历类型',sortable:true,width:300
					 ,formatter:function(value,row){
							return row.MRTypeDrDesc;
					  }
					 ,editor:{
							type:'combobox',
							options:{						
								url:$URL+"?ClassName=DHCMA.Util.BTS.DictionarySrv&QueryName=QryDictByType&aTypeCode=CPWFormMRType&ResultSetType=array",
								valueField:'BTID',
								textField:'BTDesc',
								required:true
								,onChange: function (newValue, oldValue) {
									//alert(newValue);
								}
							}
					}},
					{field:'MRTempID',title:'模板ID',sortable:true,width:150,editor:'text'},
					{field:'MRIsActiveD',title:'是否有效',width:80,
					editor:{type:'switchbox',options:{onClass:'primary',offClass:'gray',onText:'是',offText:'否'}}}
				]],	
				singleSelect:true,
				toolbar:'#tbEMR'
			});		
			
		}
		else
		{	
			obj.emrList.load({
				ClassName:"DHCMA.CPW.BTS.PathFormEpSrv",
				QueryName:"QryPathFormEpItemMR",
				aPathFormEpItemDr:obj.ItemRowData.ID
			}); 
		}		
	};
	obj.refreshPathMastEdit = function(){
		var node = obj.selPath;
		var FormPathDr = node.id.split("-Path")[0];
		var mastData = $cm({ClassName:"DHCMA.CPW.BT.PathMast",MethodName:"GetObjById",aId:FormPathDr},false);
		
		$("#txtPathCode").val(mastData.BTCode);
		$("#txtPathDesc").val(mastData.BTDesc);
		
		$('#cboTypeDr').combobox('setValue',mastData.BTTypeDr);
		$('#cboEntityDr').combobox('setValue',mastData.BTEntityDr);
		$('#cboPCEntityDr').combobox('setValue',mastData.BTPCEntityDr);
		$('#cboQCEntityDr').combobox('setValue',mastData.BTQCEntityDr);
		/*   转出多层对象处理，以字符串为准
		if (mastData.BTTypeDr!=undefined){
			$('#cboTypeDr').combobox('setValue',mastData.BTTypeDr.ID);
		}
		if (mastData.BTEntityDr!=undefined){
			$('#cboEntityDr').combobox('setValue',mastData.BTEntityDr.ID);
		}
		if (mastData.BTPCEntityDr!=undefined){
			$('#cboPCEntityDr').combobox('setValue',mastData.BTPCEntityDr.ID);
		}
		if (mastData.BTQCEntityDr!=undefined){
			$('#cboQCEntityDr').combobox('setValue',mastData.BTQCEntityDr.ID);
		}
		*/
		$("#pathMastID").val(FormPathDr);
		if(mastData.BTIsActive=="1"){
			$("#txtIsActive").switchbox('setValue',true);
		}else{
			$("#txtIsActive").switchbox('setValue',false);
		}
		
		var FormStr=$m({
			ClassName:"DHCMA.CPW.BTS.PathFormSrv",
			MethodName:"GetFormByMast",
			aMastID:FormPathDr
		},false);
		if(FormStr!=''){
			obj.lastVerID=FormStr.split("^")[0];	//有发布的，则是发布版本ID；无发布的，则是最新版本ID
			var FormData = $cm({ClassName:"DHCMA.CPW.BT.PathForm",MethodName:"GetObjById",aId:obj.lastVerID},false);
			$("#txtFormCost").val(FormData.FormCost);
			$("#txtFormDays").val(FormData.FormDays);
		}
		//第二层路径ui初始化
		if((obj.gridPathAdmit==undefined)||(obj.gridPathAdmit==null))
		{		
			obj.btnAddMrg=$HUI.linkbutton("#addIconMrg",{
				iconCls:'icon-add',
				plain:true,
				text:'新增'
			});
			obj.btnEditMrg=$HUI.linkbutton("#editIconMrg",{
				iconCls:'icon-save',
				plain:true,
				text:'保存'
			});
			obj.btnDelMrg=$HUI.linkbutton("#delIconMrg",{
				iconCls:'icon-cancel',
				plain:true,
				text:'删除'
			});
			
			obj.gridPathAdmit = $HUI.datagrid("#gridPathAdmit",{
				url:$URL,
				queryParams:{
					ClassName:"DHCMA.CPW.BTS.PathAdmitSrv",
					QueryName:"QryPathAdmit",
					aBTPathDr:""
				},
				onSelect:function(rowIndex,rowData){
					if (rowIndex<0) return;
					if (obj.gridPathAdmitEditIndex>-1){
						if (rowIndex != obj.gridPathAdmitEditIndex){
							$('#gridPathAdmit').datagrid("cancelEdit", obj.gridPathAdmitEditIndex);
						}
					}
					obj.gridPathAdmitRecRowID  = rowData["ID"];
				},
				onDblClickRow: function(rowIndex,rowData){
					if (rowIndex<0) return;
					if (obj.gridPathAdmitEditIndex>-1){
						if (rowIndex != obj.gridPathAdmitEditIndex){
							$('#gridPathAdmit').datagrid("cancelEdit", obj.gridPathAdmitEditIndex);
						}
					}
					$('#gridPathAdmit').datagrid('selectRow', rowIndex).datagrid('beginEdit', rowIndex);
				},
				onBeforeEdit: function(rowIndex, rowData, changes) {
					obj.gridPathAdmitEditIndex = rowIndex;
					obj.gridPathAdmitRecRowID  = rowData["ID"];
				},
				onAfterEdit: function(rowIndex, rowData, changes) {
					obj.gridPathAdmitEditIndex = -1;
					obj.gridPathAdmitRecRowID  = "";
				},
				onCancelEdit: function(rowIndex, rowData, changes) {
					obj.gridPathAdmitEditIndex = -1;
					obj.gridPathAdmitRecRowID  = "";
				},
				onLoadSuccess: function() {
					obj.gridPathAdmitEditIndex = -1;
					obj.gridPathAdmitRecRowID  = "";
					$('#gridPathAdmit').datagrid('clearSelections');
				},
				columns:[[
					{field:'BTTypeDr',title:'类型',sortable:true,width:100
						,formatter:function(value,row){
							return row.BTTypeDrDesc;
						}
						,editor:{
							type:'combobox',
							options:{
								url:$URL+"?ClassName=DHCMA.Util.BTS.DictionarySrv&QueryName=QryDictByType&aTypeCode=CPWAdmDiagType&aIsActive=1&ResultSetType=array",
								valueField:'BTID',
								textField:'BTDesc',
								required:true
							}
						}
					},
					{field:'BTICD10',title:'准入诊断',sortable:true,width:140,editor:'text'},
					{field:'BTICDKeys',title:'诊断关键词',sortable:true,width:150,editor:'text'},			
					{field:'BTOperICD',title:'准入手术',sortable:true,width:100,editor:'text'},
					{field:'BTOperKeys',title:'手术关键词',sortable:true,width:100,editor:'text'},
					{field:'BTIsICDAcc',title:'中西诊断组合',width:100,editor:{type:'switchbox',options:{onClass:'primary',offClass:'gray',onText:'是',offText:'否'}}},
					{field:'BTIsOperAcc',title:'诊断手术组合',width:100,editor:{type:'switchbox',options:{onClass:'primary',offClass:'gray',onText:'是',offText:'否'}}},
					{field:'BTIsActive',title:'是否有效',width:70,editor:{type:'switchbox',options:{onClass:'primary',offClass:'gray',onText:'是',offText:'否'}}}
				]],
				singleSelect:true,
				toolbar:'#tbMrg',
				fit:true
			});
			
			obj.gridPathFormSymp = $HUI.datagrid("#gridPathFormSymp",{
				fit: true,
				//title: "方剂证型维护",
				iconCls:"icon-resort",
				headerCls:'panel-header-gray',
				pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
				rownumbers: true, //如果为true, 则显示一个行号列
				singleSelect: true,
				autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
				loadMsg:'数据加载中...',
				pageSize: 10,
				pageList : [10,20,50,100,200],
				url:$URL,
				queryParams:{
					ClassName:"DHCMA.CPW.BTS.PathFormSympSrv",
					QueryName:"QryPathFormSymp",
					aBTPathDr:""
				},
				columns:[[
					{field:'FormVerDesc',title:'路径表单',width:'100',sortable:'true'},
					{field:'SympTCMDesc',title:'中药方剂',width:'150',sortable:'true'},
					{field:'SympDiagnos',title:'症候诊断',width:'250',sortable:'true'},
					{field:'ActDate',title:'操作日期',width:'100',sortable:'true'},
					{field:'ActTime',title:'操作时间',width:'80',sortable:'true'},
					{field:'ActUserDesc',title:'操作人',width:'110',sortable:'true'}
				]],
				onSelect:function(rindex,rowData){
					if (rindex>-1) {
						obj.gridPathFormSymp_onSelect();
					}
				},
				onDblClickRow:function(rowIndex,rowData){
					if(rowIndex>-1){
						obj.gridPathFormSymp_onDbselect(rowData);
					}
				},
				onLoadSuccess:function(data){
					$("#btnPathFormSympAdd").linkbutton("enable");
					$("#btnPathFormSympEdit").linkbutton("disable");
					$("#btnPathFormSympDelete").linkbutton("disable");
				}
			});
		} else {
			//重新加载datagrid的数据
			obj.gridPathAdmit.load({
				ClassName:"DHCMA.CPW.BTS.PathAdmitSrv",
				QueryName:"QryPathAdmit",
				aBTPathDr:$("#pathMastID").val()
			});
			obj.gridPathFormSymp.load({
				ClassName:"DHCMA.CPW.BTS.PathFormSympSrv",
				QueryName:"QryPathFormSymp",
				aPathMastDr:$("#pathMastID").val()
			});
		}
	};
	obj.treeClick = function(node){
		var idVal = node.id;
		obj.selPath = node;
		if(idVal.indexOf("Ver")>-1)
		{
			//第三层 表单层选中
			$("#workS").hide();
			$("#workP").hide();
			$("#workD").show();
			var valArr = idVal.split("-");
			obj.selVerID = valArr[0];  //路径表单ID
			obj.pathInfoTitle(obj.selVerID);
			$('#btnPathEdit').linkbutton({
				text:"路径信息维护"
			});
			
			//用于表单维护权限控制
			var strFormVerAct = $m({
				ClassName: "DHCMA.CPW.BTS.PathFormSrv",
				MethodName: "CheckFormVerAct",
				aFormID: obj.selVerID
			}, false);
			if (strFormVerAct){
				var arrFormVerAct = strFormVerAct.split("^");
				obj.CurrForm.ID       = arrFormVerAct[0];
				obj.CurrForm.PathDesc = arrFormVerAct[1];
				obj.CurrForm.Version  = arrFormVerAct[2];
				obj.CurrForm.IsActive = arrFormVerAct[3];
				obj.CurrForm.IsOpen   = arrFormVerAct[4];
			} else {
				obj.CurrForm.ID       = "";
				obj.CurrForm.PathDesc = "";
				obj.CurrForm.Version  = "";
				obj.CurrForm.IsActive = 0;
				obj.CurrForm.IsOpen   = 0;
			}
			
			obj.epRefresh();  //其中会用到表单维护权限控制
			if ((obj.CurrForm.IsActive!=0)&&(obj.CurrForm.IsOpen!=1)){
				$("#addIconMrgl,#addIconMrgh,#addIconMrgz,#syncIconMrgz").linkbutton("enable");	
				$("#editIconMrgl,#editIconMrgh,#editIconMrgz").linkbutton("disable");	
				$("#delIconMrgl,#delIconMrgh,#delIconMrgz").linkbutton("disable");
			}else{
				$("#addIconMrgl,#addIconMrgh,#addIconMrgz").linkbutton("disable");
				$("#editIconMrgl,#editIconMrgh,#editIconMrgz").linkbutton("disable");
				$("#delIconMrgl,#delIconMrgh,#delIconMrgz,#syncIconMrgz").linkbutton("disable");
			}			
		}
		else if(idVal.indexOf("Path")>-1)
		{
			//第二层 路径
			$("#workP").show();
			$("#workS").hide();
			$("#workD").hide();
			obj.refreshPathMastEdit();
			//重新加载datagrid的数据  
			obj.gridPathAdmit.load({
				ClassName:"DHCMA.CPW.BTS.PathAdmitSrv",
				QueryName:"QryPathAdmit",
				aBTPathDr:$("#pathMastID").val()
			});
			obj.gridPathFormSymp.load({
				ClassName:"DHCMA.CPW.BTS.PathFormSympSrv",
				QueryName:"QryPathFormSymp",
				aPathMastDr:$("#pathMastID").val()
			});
			obj.selVerID = "";
		}
		else
		{
			//第一层
			$("#workS").show();
			$("#workP").hide();
			$("#workD").hide();
			obj.selVerID = "";
		}
		$('#treeType').tree('toggle', node.target);	
	};
	
	//准入提示信息--保存编辑行
	obj.savegridPathAdmitRow=function(rowData){
		var ID          = rowData["ID"];
		var BTPathDr    = rowData["BTPathDr"];
		var BTTypeDr    = rowData["BTTypeDr"];
		var BTICD10     = rowData["BTICD10"];
		var BTICDKeys   = rowData["BTICDKeys"];
		var BTOperICD   = rowData["BTOperICD"];
		var BTOperKeys  = rowData["BTOperKeys"];
		var BTIsICDAcc  = rowData["BTIsICDAcc"];
		var BTIsOperAcc = rowData["BTIsOperAcc"];
		var BTIsActive  = rowData["BTIsActive"];
		
		BTIsICDAcc = (BTIsICDAcc =="是"?"1":"0");
		BTIsOperAcc = (BTIsOperAcc =="是"?"1":"0");
		BTIsActive = (BTIsActive =="是"?"1":"0");
		if(BTTypeDr==""){
			$.messager.alert("提示","诊断类型不可以为空！");
			return "";
		}
		
		var InputStr = ID;
		InputStr += "^" + BTPathDr;
		InputStr += "^" + BTTypeDr;
		InputStr += "^" + BTICD10;
		InputStr += "^" + BTICDKeys;
		InputStr += "^" + BTOperICD;
		InputStr += "^" + BTOperKeys;
		InputStr += "^" + BTIsICDAcc;
		InputStr += "^" + BTIsOperAcc;
		InputStr += "^" + BTIsActive;
		InputStr += "^";
		InputStr += "^";
		InputStr += "^" + session['DHCMA.USERID'];
		//同步调用
		var ret = $.cm({ClassName:"DHCMA.CPW.BT.PathAdmit",MethodName:"Update",
				"aInputStr":InputStr,
				"aSeparete":"^"
			},false);
		if(parseInt(ret)<0){
			$.messager.popover({msg:"保存失败",type:'error',style:{top:250,left:600}});
			return "";
		}else{
			$.messager.popover({msg:"保存成功",type:'success',style:{top:250,left:600}});			
		}
		return ret; //保存成功返回rowID、保存失败返回空
	};
	//准入提示信息--删除选中行
	obj.deletegridPathAdmitRow= function(){
		if (obj.gridPathAdmitRecRowID!=""){
			$.messager.confirm("确认","确定删除?",function(r){
				if(r){					
					$.cm({ClassName:'DHCMA.CPW.BT.PathAdmit',MethodName:'DeleteById','aId':obj.gridPathAdmitRecRowID},function(data){
						//debugger;
						if(parseInt(data)<0){
							$.messager.alert("提示","失败！");  //data.msg
						}else{							
							//重新加载datagrid的数据  
							obj.gridPathAdmit.load({
								ClassName:"DHCMA.CPW.BTS.PathAdmitSrv",
								QueryName:"QryPathAdmit",
								aBTPathDr:$("#pathMastID").val() 
							}); 
						}
					});
				}
			});
		}else{
			$.messager.alert("提示","请先选中行，再执行删除操作！")
		}
	};
///datagrid无数据滚动条处理(添加与头列同宽的div)   入参:datagrid的ID
function addDivToGrid(){
	if (typeof(arguments[0]) !== 'string') return false;
	if (arguments[0] == '') return false;
	
	var $this = $('#'+ arguments[0]);
	if ($this.length < 1) return false;
	var length=$this.datagrid("options").columns[0].length;
	var width=4;
	for (var i=0;i<length;i++){
		var wid=parseInt($("#gridHl").datagrid("options").columns[0][i].width)
		width=width+wid
	}
	$this.parent().find(".datagrid-view2 .datagrid-body").html("<div style='width:"+width+"px;border:solid 0px;height:1px;'></div>");
	return true
}
	
	//方剂证型维护-选择事件
	obj.gridPathFormSymp_onSelect = function(){
		if($("#btnPathFormSympEdit").hasClass("l-btn-disabled")) obj.PathFormSympDr="";
		var rowData = obj.gridPathFormSymp.getSelected();
		if (rowData["PathFormSympDr"] == obj.PathFormSympDr) {
			$("#btnPathFormSympAdd").linkbutton("enable");
			$("#btnPathFormSympEdit").linkbutton("disable");
			$("#btnPathFormSympDelete").linkbutton("disable");
			obj.PathFormSympDr = "";
			obj.gridPathFormSymp.clearSelections();  //清除选中行
		} else {
			obj.PathFormSympDr = rowData["PathFormSympDr"];
			$("#btnPathFormSympAdd").linkbutton("disable");
			$("#btnPathFormSympEdit").linkbutton("enable");
			$("#btnPathFormSympDelete").linkbutton("enable");
		}
	}
	//方剂证型维护-双击编辑事件
	obj.gridPathFormSymp_onDbselect = function(rd){
		obj.PathFormSympEdit(rd);	
	}
	//方剂证型维护-删除事件
	obj.btnPathFormSympDelete_click = function(){
		var rowData = obj.gridPathFormSymp.getSelected();
		var rowID=rowData["PathFormSympDr"]
		if (rowID==""){
			$.messager.alert("提示", "选中数据记录,再点击删除!", 'info');
		}
		$.messager.confirm("删除", "是否删除选中数据记录?", function (r) {				
			if (r) {				
				var flg = $m({
					ClassName:"DHCMA.CPW.BT.PathFormSymp",
					MethodName:"DeleteById",
					aId:rowID
				},false);
				if (parseInt(flg) < 0) {
					$.messager.alert("错误提示","删除数据错误!Error=" + flg, 'info');	
				} else {
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					obj.PathFormSympDr="";
					obj.gridPathFormSymp.reload();//刷新当前
				}
			} 
		});
	}
	//方剂证型维护-保存事件
	obj.btnPathFormSympSave_click = function(){
		var errinfo = "";
		var inputStr= ""
		
		var PathFormDr = '';
		var FormSympSub = '';
		
		if (obj.PathFormSympDr !=''){
			var tmp = obj.PathFormSympDr;
			var arr = tmp.split('||');
			PathFormDr = arr[0];
			FormSympSub = arr[1];
		} else {
			PathFormDr = $('#cboPathForm').combobox('getValue');
		}
		
		//取证型
		var SympDiagnos = obj.cboSympDiagnos.getValues().join(',');
		if (SympDiagnos.substr(0,1)==','){
			SympDiagnos=SympDiagnos.slice(1,SympDiagnos.length);
		} 
		
		var SympTCMDr = $('#cboSympTCM').combobox('getValue');
		
		if (!PathFormDr) {
			errinfo = errinfo + "路径表单为空!<br>";
		}
		if (!SympDiagnos) {
			errinfo = errinfo + "症候诊断为空!<br>";
		}else if(SympDiagnos.length<2){
			errinfo = errinfo + "症候诊断最少输入2个字符!<br>";
		}
		if (!SympTCMDr) {
			errinfo = errinfo + "中药方剂为空!<br>";
		}
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		
		var inputStr = PathFormDr;
		inputStr = inputStr + CHR_1 + FormSympSub;
		inputStr = inputStr + CHR_1 + SympDiagnos;
		inputStr = inputStr + CHR_1 + SympTCMDr;
		inputStr = inputStr + CHR_1 + '';
		inputStr = inputStr + CHR_1 + '';
		inputStr = inputStr + CHR_1 + session['DHCMA.USERID'];
		
		$cm({
				ClassName:"DHCMA.CPW.BTS.PathFormSympSrv",
				MethodName:"CheckIsSave",
				aInStr:inputStr,
				aSeparete:CHR_1
		},function(CheckFlg){
			if (parseInt(CheckFlg)==1){
			var flg = $m({
				ClassName:"DHCMA.CPW.BT.PathFormSymp",
				MethodName:"Update",
				aInStr:inputStr,
				aSeparete:CHR_1
			},false);
			if (parseInt(flg) <= 0) {
				if (parseInt(flg) == 0) {
					$.messager.alert("错误提示", "参数错误!", 'info');
				} else {
					$.messager.alert("错误提示", "更新数据错误!Error=" + flg, 'info');
				}
			}else {
				$HUI.dialog('#winPathFormSympEdit').close();
				$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
				obj.PathFormSympDr =flg
				obj.gridPathFormSymp.reload() ;//刷新当前页
			}
		}else{
			$.messager.alert("错误提示", "该路径版本下已存在此中草药方剂记录!", 'info');
			}
		});
	}
	//方剂证型维护-编辑弹窗
	obj.getComboboxVal = function(Str){
		var flg = $m({
				ClassName:"DHCMA.CPW.BTS.PathFormSympSrv",
				QueryName:"QuerySetPattern",
				ResultSetType:'array',
				aAlias:""
			},false);
		var ret = JSON.parse(flg);
		var StrArr = Str.split(",");
		for(var j=0;j<StrArr.length;j++){
			var strId = StrArr[j]
			for (var i=0;i<ret.length;i++){
				if(strId==ret[i].SympDiaID){
					$("#cboSympDiagnos").combobox("setValue",ret[i].SympDiaID);
				}
			}
		}
	}
	
	obj.PathFormSympEdit= function(rd){
		//obj.cboSympTCM.reload();
		obj.cboPathForm.reload();
		//obj.cboSympDiagnos.reload();
		//obj.cboSearchKey.reload();
		if(rd){
			$("#cboPathForm").combobox({disabled:true});
			obj.PathFormSympDr=rd["PathFormSympDr"];
			var PathFormDr = rd["PathFormDr"];
			var SympDiagIDs = rd["SympDiagIDs"];
			var arrSympDiagIDs=SympDiagIDs.split(",");
			var SympDiagnos = rd["SympDiagnos"];
			var SympTCMDr = rd["SympTCMDr"];
			$('#cboPathForm').combobox('setValue',PathFormDr);
			$('#cboSympTCM').combobox('setValue',SympTCMDr);
			obj.cboSympDiagnos.setValues(arrSympDiagIDs);
			obj.cboSympDiagnos.setText(SympDiagnos);
		}else{
			obj.PathFormSympDr="";
			$("#cboPathForm").combobox({disabled:false});
			$('#cboPathForm').combobox('setValue','');
			$('#cboSympDiagnos').combobox('setValue','');
			$('#cboSympTCM').combobox('setValue','');
		}
		$HUI.dialog('#winPathFormSympEdit').open();
	}
}

function SearchPath(){
	$('#treeType').tree({
		url:$URL+"?ClassName=DHCMA.CPW.BTS.PathFormSrv&QueryName=QryLocPathVer&argNodeID=-root&argLocID="+obj.LocID+"&argAdmType="+obj.CurrAdmType+"&argHospID="+obj.cboHospValue+"&argDesc="+""+"&argKeyWords="+""+"&ResultSetType=array"	
		,onLoadSuccess:function(node,data)
		{
			//回调
		}
	});	
	
	$('#treeType').tree('reload')
	$HUI.dialog('#winPathSearch').close();
}
