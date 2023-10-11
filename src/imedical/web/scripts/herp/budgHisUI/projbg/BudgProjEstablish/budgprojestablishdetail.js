Detail = function(){ 
var userid = session['LOGON.USERID'];
var hospid=session['LOGON.HOSPID'];   
     
    DetailColumns=[[  
                {field:'ckbox',checkbox:true},//复选框
                {field:'rowid',title:'明细ID',width:80,hidden: true},
	            {field:'projadjdr',title:'主表ID',width:80,hidden:true},
                {field:'fundtypedr',title:'资金类别ID',width:80,hidden: true},
                {field:'fundtype',title:'资金类别',width:120},
                {field:'itemcode',title:'科目编码',width:120},
                {field:'itemname',title:'科目名称',width:120},
                {field:'bidlevel',title:'预算级别',width:120,hidden:true},
                {field:'bidislast',title:'是否末级',width:120,hidden:true},
                {field:'budgprice',title:'预算单价(元)',width:120},
                {field:'budgnum',title:'预算数量',width:120},
                {field:'budgvalue',title:'预算金额(元)',width:120},
                {field:'budgpro',title:'总预算占比(%)',width:120},
                {field:'username',title:'编制人',width:120},
                {field:'deptdr',title:'编制人科室ID',width:120,hidden:true},
                {field:'deptname',title:'编制人科室',width:150,},
                {field:'state',title:'状态',width:60,hidden:true},
                {field:'isaddeditlist',title:'新增/更新',width:120,hidden:true},
                {field:'isaddedit',title:'新增/更新',width:120},
                {field:'budgdesc',title:'设备名称备注',width:180},
	            {field:'PerOrigin',title:'人员资质-原有设备',width:180},
	            {field:'FeeScale',title:'收费标准',width:120},
	            {field:'AnnBenefit',title:'年效益预测',width:150},
	            {field:'MatCharge',title:'耗材费',width:120},
	            {field:'SupCondit',title:'配套条件',width:120},
	            {field:'Remarks',title:'说明',width:200},
	            {field:'brand1',title:'推荐品牌1',width:150},
	            {field:'spec1',title:'规格型号1',width:150},
	            {field:'brand2',title:'推荐品牌2',width:150},
	            {field:'spec2',title:'规格型号2',width:150},
	            {field:'brand3',title:'推荐品牌3',width:150},
	            {field:'spec3',title:'规格型号3',width:150}
            ]];
    var DetailGridObj = $HUI.datagrid("#DetailGrid",{
        url:$URL,
        queryParams:{
            ClassName:"herp.budg.hisui.udata.uBudgProjEstablish",
            MethodName:"ListDetail",
            hospid :    hospid, 
            projadjdr :    ""          
        },
        delay:200,
        fitColumns: false,
        loadMsg:"正在加载，请稍等…",
        autoRowHeight: true,
        rownumbers:true,//行号
		striped:true,
        pageSize:20,
        pageList:[10,20,30,50,100], //页面大小选择列表
        pagination:true,//分页
        fit:true,
        columns:DetailColumns,
        toolbar: '#dtb'       
    }); 
	
	//验证必填项	
	function ChkPef(){
	if(($('#BItembox').combobox('getValue')=="")||($('#BPricebox').val()=="")||($('#BNumbox').val()=="")||($('#BDeptbox').combobox('getValue')=="")||($('#BAEbox').combobox('getValue')=="")){
		$.messager.popover({
					msg: '必选项不能为空！',
					type: 'alert',
					style: {
						left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
						top:10
					}
				});
				return false;
	}
	return true;	
	};

    //新增
	var AddBtn=function(){
    //未选中明细，提示信息
	var rowObj = $('#MainGrid').datagrid('getSelected');
	var rows = $('#MainGrid').datagrid('getSelections');
	if(rows.length!=1){
	$.messager.popover({
					msg: '请选择一条项目!',
					type: 'alert',
					style: {
						left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
						top:10
					}
				}); ;
				return false;
	};		
		var $win; 
		$("#Detailff").form('clear');
		$win = $('#Add').window({
				title: '添加项目明细信息',
				width: 800,
				height: 575,
				top: ($(window).height() - 600) * 0.5,
				left: ($(window).width() - 900) * 0.5,
				shadow: true,
				modal: true,
				iconCls: 'icon-add',
				closed: true,
				minimizable: false,
				maximizable: false,
				collapsible: false,
				resizable: true,
				onClose: function () { //关闭关闭窗口后触发
					$("#DetailGrid").datagrid("reload"); //关闭窗口，重新加载明细表格
				}
			});
		$win.window('open');
	// 预算科目的下拉框
    var AddItemObj = $HUI.combobox("#BItembox",{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=ItemName",
        mode:'remote',
        delay:200,
        valueField:'rowid',    
        textField:'name',
        onBeforeLoad:function(param){
            param.hospid = hospid;
            //param.year 	 = $('#BYMbox').combobox('getValue');
            //param.deptdr = $('#BDutybox').combobox('getValue');
            param.str 	 = param.q;
        },
	});
    // 资金类型的下拉框
    var AddFundTyObj = $HUI.combobox("#BFundTypebox",{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=FundType",
        mode:'remote',
        valueField:'fundTypeId',    
        textField:'fundTypeNa',
        onBeforeLoad:function(param){
            param.str = param.q;
        },
    });
	// 预算科室的下拉框
    var AddBgDeptObj = $HUI.combobox("#BDeptbox",{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=Deptnamelist",
        mode:'remote',
        delay:200,
        valueField:'rowid',    
        textField:'name',
        onBeforeLoad:function(param){
            param.str = param.q;
        }
    });
	// 更新/新增
	var BAEboxObj = $HUI.combobox("#BAEbox",{
		mode:'remote',
		valueField:'id',
		textField:'text',
		data:[{id:'1',text:'新增'},{id:'2',text:'更新'}]
	});
	//预算单价变化，计算预算金额
    $('#BPricebox').keyup(function(event){
    	Calcu();
    })
    //预算数量变化，计算预算金额
    $('#BNumbox').numberspinner({
    	onChange:function(n,o){
    		if(n!=o){
    			Calcu();
    		}
    	}   	
    }) 
    //计算预算金额 = 单价*数量 
    function Calcu(){
    	var AddPrice = parseFloat($('#BPricebox').val());  //预算单价
    	if (AddPrice ==""||isNaN(AddPrice)){AddPrice = 0};
    	var AddNum = parseFloat($('#BNumbox').val()); //预算数量
    	if (AddNum ==""||isNaN(AddNum)){AddNum = 0};
    	$('#BSumbox').val(AddPrice.toFixed(2)*AddNum.toFixed(0));
    }
	$("#BtchSave").unbind('click').click(function(){
		var fundtype=$('#BFundTypebox').combobox('getValue');//资金类型
		var bannben=$('#BAnnBenbox').val();//年效益预测
		var bitem=$('#BItembox').combobox('getValue');//预算科目
		var bmatchar=$('#BMatCharbox').val();//耗材费
		var bprice =$('#BPricebox').val();//预算单价
		var bsupcon =$('#BSupConbox').val();//配套条件
		var bnum =$('#BNumbox').val();//预算数量
		var bremar =$('#BRemarkbox').val();//说明
		var bsum =$('#BSumbox').val();//预算金额
		var bbrand1 =$('#BBrand1box').val();//推荐品牌1
		var bperce =$('#BPercebox').val();//预算总占比
		var bspec1 =$('#BSpec1box').val();//规格型号1
		var bdept =$('#BDeptbox').combobox('getValue');//预算科室
		var bbrand2 =$('#BBrand2box').val();
		var bae =$('#BAEbox').combobox('getValue');//新增/更新
		var bspec2 =$('#BSpec2box').val();
		var bequremark =$('#BEquRemarkbox').val();//设备名称备注
		var bbrand3 =$('#BBrand3box').val();
		var bfeesca =$('#BFeeScabox').val();//收费标准
		var bspec3 =$('#BSpec3box').val();
		var bperori =$('#BPerOribox').val();//人员资质—原有设备
		
	
	
    if(ChkPef()==true){
		//获取主表的年度,主表ID,获取编制人
		var rows = $('#MainGrid').datagrid('getSelections');
		for(var i=0;i<rows.length;i++){
			var year=rows[i]['year'];
            var projadjdr=rows[i]['projadjdr'];	
            var uname=rows[i]['username'];			
		};
		//alert(year);
		//alert (projadjdr);
		//alert(uname);
		//alert(bdept);
		var datad = projadjdr + '|' + year + '|' + bitem + '|' + bprice + '|' + bnum + '|' + bsum 
		+ '|' + bequremark + '|' + bfeesca + '|' + bannben + '|' + bmatchar + '|' + bsupcon 
		+ '|' + bremar + '|' + bbrand1 + '|' + bspec1 + '|' + bbrand2 + '|' + bspec2 
		+ '|' + bbrand3 + '|' + bspec3 + '|' + bae + '|' + bperori + '|' + userid 
		+ '|' + uname + '|' + fundtype + '|' + bperce + '|' + hospid + '|' + bdept;
		//alert(datad);
		$.m({
            ClassName:'herp.budg.hisui.udata.uBudgProjEstablish',MethodName:'InsertDetail',data:datad},
            function(Data){
                if(Data==0){
                    $.messager.popover({
					msg: "保存成功！",
					type: 'success',
					style: {
						left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
						top: 10
					}
				});
                }else{
	                $.messager.popover({
					msg: '错误信息:' +Data,
					type: 'error',
					style: {
						left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
						top: 10
					}
				});
          
                }
            }
        );
		$win.window('close');
	};	
		
	});
    $("#BtchClose").unbind('click').click(function(){
        $win.window('close');
    });
    }
	//点击新增按钮
	$("#AddBn").click(AddBtn);
	
	
	//修改
	var UpdaBtn=function(){
	//未选中明细，提示信息
	var rowObj = $('#DetailGrid').datagrid('getSelected');
	var rowMainObj = $('#MainGrid').datagrid('getSelected');
	var rows = $('#DetailGrid').datagrid('getSelections');
	if(rows.length!=1){
	$.messager.popover({
					msg: '请选择一条数据修改!',
					type: 'alert',
					style: {
						left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
						top:10
					}
				}); ;
				return false;
	};
	$("#Detailff").form('clear');
		var $win; 
		$win = $('#Add').window({
				title: '修改项目明细信息',
				width: 800,
				height: 575,
				top: ($(window).height() - 600) * 0.5,
				left: ($(window).width() - 900) * 0.5,
				shadow: true,
				modal: true,
				iconCls: 'icon-write-order',
				closed: true,
				minimizable: false,
				maximizable: false,
				collapsible: false,
				resizable: true,
				onClose: function () { //关闭关闭窗口后触发
					$("#DetailGrid").datagrid("reload"); //关闭窗口，重新加载主表格
				}
			});
	    $win.window('open');
		var rowid = rowObj.rowid;//明细ID
		var year = rowMainObj.year;//主表年度
		var uname = rowMainObj.username;//编制人
		var projadjdr = rowObj.projadjdr;//主表ID
		var fundtype=rowObj.fundtypedr;//资金类型
		var bannben=rowObj.AnnBenefit;//年效益预测
		var itemcode=rowObj.itemcode;
		var bitem=rowObj.itemname;//预算科目
		var bmatchar=rowObj.MatCharge;//耗材费
		var bprice =rowObj.budgprice;//预算单价
		var bsupcon =rowObj.SupCondit;//配套条件
		var bnum =rowObj.budgnum;//预算数量
		var bremar =rowObj.Remarks;//说明
		var bsum =rowObj.budgvalue;//预算金额
		var bbrand1 =rowObj.brand1;//推荐品牌1
		var bperce =rowObj.budgpro;//预算总占比
		var bspec1 =rowObj.spec1;//规格型号1
		var bdept =rowObj.deptdr;//预算科室
		var bbrand2 =rowObj.brand2;
		var bae =rowObj.isaddedit;//新增/更新
		if(bae =="新增"){
			bae = 1;
		}else{
			bae = 2;
		};
		var bspec2 =rowObj.spec2;
		var bequremark =rowObj.budgdesc;//设备名称备注
		var bbrand3 =rowObj.brand3;
		var bfeesca =rowObj.FeeScale;//收费标准
		var bspec3 =rowObj.spec3;
		var bperori =rowObj.PerOrigin;//人员资质—原有设备
		
	// 预算科目的下拉框
    var AddItemObj = $HUI.combobox("#BItembox",{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=ItemName",
        mode:'remote',
        delay:200,
        valueField:'rowid',    
        textField:'name',
        onBeforeLoad:function(param){
            param.hospid = hospid;
            //param.year 	 = $('#BYMbox').combobox('getValue');
            //param.deptdr = $('#BDutybox').combobox('getValue');
            param.str 	 = param.q;
        },
	});
    // 资金类型的下拉框
    var AddFundTyObj = $HUI.combobox("#BFundTypebox",{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=FundType",
        mode:'remote',
        valueField:'fundTypeId',    
        textField:'fundTypeNa',
        onBeforeLoad:function(param){
            param.str = param.q;
        },
    });
	
	// 预算科室的下拉框
    var AddBgDeptObj = $HUI.combobox("#BDeptbox",{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=Deptnamelist",
        mode:'remote',
        delay:200,
        valueField:'rowid',    
        textField:'name',
        onBeforeLoad:function(param){
            param.str = param.q;
        }
    });
	// 更新/新增
	var BAEboxObj = $HUI.combobox("#BAEbox",{
		mode:'remote',
		valueField:'id',
		textField:'text',
		data:[{id:'1',text:'新增'},{id:'2',text:'更新'}]
	});
	//预算单价变化，计算预算金额
    $('#BPricebox').keyup(function(event){
    	Calcu();
    });
    //预算数量变化，计算预算金额
    $('#BNumbox').numberspinner({
		value:bnum,
    	onChange:function(n,o){
    		if(n!=o){
    			Calcu();
    		}
    	}   	
    }); 
    //计算预算金额 = 单价*数量 
    function Calcu(){
    	var EditPrice = parseFloat($('#BPricebox').val());  //预算单价
    	if (EditPrice ==""||isNaN(EditPrice)){EditPrice = 0};
    	var EditNum = parseFloat($('#BNumbox').val()); //预算数量
    	if (EditNum ==""||isNaN(EditNum)){EditNum = 0};
    	$('#BSumbox').val(EditPrice.toFixed(2)*EditNum.toFixed(0));
    };
		
		$('#BFundTypebox').combobox('setValue',fundtype);
		$('#BAnnBenbox').val(bannben);
		$('#BItembox').combobox('setValue',bitem);
		$('#BMatCharbox').val(bmatchar);
		$('#BPricebox').val(bprice);
		$('#BSupConbox').val(bsupcon);
		$('#BNumbox').val(bnum);
		$('#BRemarkbox').val(bremar);
		$('#BSumbox').val(bsum);
		$('#BBrand1box').val(bbrand1);
		$('#BPercebox').val(bperce);
		$('#BSpec1box').val(bspec1);
		$('#BDeptbox').combobox('setValue',bdept);
		$('#BBrand2box').val(bbrand2);
		$('#BAEbox').combobox('setValue',bae);
		$('#BSpec2box').val(bspec2);
		$('#BEquRemarkbox').val(bequremark);
		$('#BBrand3box').val(bbrand3);
		$('#BFeeScabox').val(bfeesca);
		$('#BSpec3box').val(bspec3);
		$('#BPerOribox').val(bperori);
		//添加方法 
    $("#BtchSave").unbind('click').click(function(){
        var fundtype=$('#BFundTypebox').combobox('getValue');//资金类型
		var bannben=$('#BAnnBenbox').val();//年效益预测
		var bitem=$('#BItembox').combobox('getValue');//预算科目
		var bmatchar=$('#BMatCharbox').val();//耗材费
		var bprice =$('#BPricebox').val();//预算单价
		var bsupcon =$('#BSupConbox').val();//配套条件
		var bnum =$('#BNumbox').val();//预算数量
		var bremar =$('#BRemarkbox').val();//说明
		var bsum =$('#BSumbox').val();//预算金额
		var bbrand1 =$('#BBrand1box').val();//推荐品牌1
		var bperce =$('#BPercebox').val();//预算总占比
		var bspec1 =$('#BSpec1box').val();//规格型号1
		var bdept =$('#BDeptbox').combobox('getValue');//预算科室
		var bbrand2 =$('#BBrand2box').val();
		var bae =$('#BAEbox').combobox('getValue');//新增/更新
		var bspec2 =$('#BSpec2box').val();
		var bequremark =$('#BEquRemarkbox').val();//设备名称备注
		var bbrand3 =$('#BBrand3box').val();
		var bfeesca =$('#BFeeScabox').val();//收费标准
		var bspec3 =$('#BSpec3box').val();
		var bperori =$('#BPerOribox').val();//人员资质—原有设备
		
		if(ChkPef()==true){
		//获取主表的年度,主表ID,获取编制人
		var rows = $('#MainGrid').datagrid('getSelections');
		for(var i=0;i<rows.length;i++){
			var year=rows[i]['year'];
            var projadjdr=rows[i]['projadjdr'];	
            var uname=rows[i]['username'];			
		};
		//alert('年度：'+year);
		//alert('主表ID：'+projadjdr);
		//alert('科室编码：'+itemcode);
        //alert('资金类别:'+ fundtype);		
		var datad = projadjdr + '|' + year + '|' + itemcode + '|' + bprice + '|'+ bnum + '|' + bsum + '|' + bequremark + '|' + bfeesca  
		+ '|' + bannben + '|' + bmatchar + '|' + bsupcon + '|' + bremar + '|' + bbrand1 
		+ '|' + bspec1 + '|' + bbrand2 + '|' + bspec2 + '|' + bbrand3 + '|' + bspec3
		+ '|' + bae + '|' + bperori + '|' + userid + '|' + uname + '|' + fundtype 
		+ '|' + bperce + '|' + hospid + '|' + bdept;
		//alert(rowid);
		//alert(datad);
        $.m({
            ClassName:'herp.budg.hisui.udata.uBudgProjEstablish',MethodName:'UpdateDetail',detailrowid:rowid,data:datad},
            function(Data){
                if(Data==0){
                    $.messager.popover({
					msg: "保存成功！",
					type: 'success',
					style: {
						left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
						top: 10
					}
				});
                }else{
	                $.messager.popover({
					msg: '错误信息:' +Data,
					type: 'error',
					style: {
						left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
						top: 10
					}
				});
                }
            }
        );
         $win.window('close');
		}
    });
    $("#BtchClose").unbind('click').click(function(){
        $win.window('close');
    });
		
	}; //修改函数后括号

    //点击修改按钮
	$("#UpdataBn").click(UpdaBtn);
    
    //删除
	var DelBtn=function(){
	
		$.messager.confirm('确定','确定要删除选定的数据吗？',function(t){
           if(t){
			   
			var mainRows = $('#MainGrid').datagrid('getSelections');
			var mainLen = mainRows.length;
			for(var j=0;j<mainLen;j++){
				var uname=mainRows[j]['username'];
			};
			
            var rows = $('#DetailGrid').datagrid('getSelections');
            var len = rows.length;
			for(var i=0;i<rows.length;i++){
				var rowid=rows[i]['rowid'];
				var projadjdr=rows[i]['projadjdr'];
                $.m({
                ClassName:'herp.budg.hisui.udata.uBudgProjEstablish',
				MethodName:'DelDetail',
				userId:userid,
				uname:uname,
				detailrowid:rowid,
				projadjdr:projadjdr,
				hospid:hospid},
                function(Data){
                    if(Data==0){
	                $.messager.popover({
					msg: '删除成功！',
					type: 'success',
					style: {
						left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
						top: 10
					}
					
				});
                $('#DetailGrid').datagrid("reload")
                    }else{
	                     $.messager.popover({
					msg: '删除失败! 错误信息:' +Data,
					type: 'error',
					style: {
						left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
						top: 10
					}
				});
                $('#DetailGrid').datagrid("reload")
              
                    }
                }
            );
			}; 
           } 
        })  
	 
	}
	
	//点击删除按钮
	$("#DelBn").click(DelBtn);	
	
    
	
    
}