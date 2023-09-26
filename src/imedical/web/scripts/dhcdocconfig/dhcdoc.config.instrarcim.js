﻿	//定义全局变量
	var instrDataGrid; //定义全局变量datagrid
    var editRow = undefined; //定义全局变量：当前编辑的行
    
    var oPInstrArcimDataGrid;
    var editRow2 =undefined;
    var AddeditRow2=undefined;
    
    var iPInstrArcimDataGrid;
    var editRow3 =undefined;
    var AddeditRow3=undefined;
    
    var oPInstrArcimSelDataGrid;
    var editRow4 =undefined;
    var AddeditRow4=undefined;
    
    var iPInstrArcimSelDataGrid;
    var editRow5 =undefined;
    var AddeditRow5=undefined;
$(function(){
	InitHospital();
	InitDefSpeedRateUnit();
	$("#BSaveInstrProperty").click(SaveInstrProperty);
	/*$("#Combo_Hospital").combobox({
       onChange: function (o) {	
	       if ($("#Check_UseHospSepInstrArcim").is(":checked")) {
			   var select = instrDataGrid.datagrid("getSelected");	  
               if(select){
				   var InstrRowID=select.InstrRowID;
			       loadOPInstrArcimDataGrid(InstrRowID);
			       loadIPInstrArcimDataGrid(InstrRowID);
			       LoadSaveInstrProperty(InstrRowID);
			       //loadOPInstrArcimSelDataGrid(InstrRowID);
			       //loadIPInstrArcimSelDataGrid(InstrRowID);
			   }			   
		   }  
       }
   })*/
	///用法列表columns
    instrColumns=[[    
        			{ field: 'InstrDesc', title: '用法名称', width: 100},
					{ field: 'InstrRowID', title: '用法ID', width: 100,hidden:true}
    			 ]];
     // 用法列表Grid
	instrDataGrid=$('#tabInstrList').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		url:$URL+"?ClassName=DHCDoc.DHCDocConfig.InstrArcim&QueryName=FindInstr&InstrAlias=",
		loadMsg : '加载中..',  
		pagination : true,  //
		rownumbers : true,  //
		idField:"InstrRowID",
		pageSize:15,
		pageList : [15,50,100,200],
		//frozenColumns : FrozenCateColumns,
		columns :instrColumns,
		onClickRow:function(rowIndex, rowData){
			instrDataGrid.datagrid('selectRow',rowIndex);
			var selected=instrDataGrid.datagrid('getRows'); 
			var InstrRowID=selected[rowIndex].InstrRowID;
			loadOPInstrArcimDataGrid(InstrRowID);
			loadIPInstrArcimDataGrid(InstrRowID);
			LoadSaveInstrProperty(InstrRowID);
			//loadOPInstrArcimSelDataGrid(InstrRowID);
			//loadIPInstrArcimSelDataGrid(InstrRowID);
		}
	});
	//-------------自动关联医嘱 门诊关联医嘱代码---------------
	var oPInstrArcimToolBar = [{
            text: '增加',
            iconCls: 'icon-add',
            handler: function() { //添加列表的操作按钮添加,修改,删除等
                 editRow2 = undefined;
                oPInstrArcimDataGrid.datagrid("rejectChanges");
                oPInstrArcimDataGrid.datagrid("unselectAll");

                if (editRow2 != undefined) {
                    oPInstrArcimDataGrid.datagrid("endEdit", editRow2);
                    return;
                }else{
	                 //添加时如果没有正在编辑的行，则在datagrid的第一行插入一行
                    oPInstrArcimDataGrid.datagrid("insertRow", {
                        index: 0,
                        // index start with 0
                        row: {

						}
                    });
                    //将新插入的那一行开户编辑状态
                    oPInstrArcimDataGrid.datagrid("beginEdit", 0);
                    //cureItemDataGrid.datagrid('addEditor',LocDescEdit);
                    //给当前编辑的行赋值
                    editRow2 = 0;
                    AddeditRow2=0;
                    /*var ByDayObj = oPInstrArcimDataGrid.datagrid("getEditor",{index:editRow2,field:'ByDay'});
					var InfusionFeeFlagObj = oPInstrArcimDataGrid.datagrid("getEditor",{index:editRow2,field:'InfusionFeeFlag'});
					ByDayObj.target.change(function(){
						if(ByDayObj.target.is(':checked')) {
							InfusionFeeFlagObj.target.attr("checked",false)
						}
					})
					InfusionFeeFlagObj.target.change(function(){
						if(InfusionFeeFlagObj.target.is(':checked')) {
							ByDayObj.target.attr("checked",false)
						}
					})*/
                }
              
            }
        },{
            text: '删除',
            iconCls: 'icon-cancel',
            handler: function() {
                //删除时先获取选择行
                var rows = oPInstrArcimDataGrid.datagrid("getSelections");
                //选择要删除的行
                if (rows.length > 0) {
                    $.messager.confirm("提示", "你确定要删除吗?",
                    function(r) {
                        if (r) {
                            var ids = [];
                            for (var i = 0; i < rows.length; i++) {
                                ids.push(rows[i].InstrArcimId);
                            }
                            //将选择到的行存入数组并用,分隔转换成字符串，
                            //本例只是前台操作没有与数据库进行交互所以此处只是弹出要传入后台的id
                            //console.info(ids);
                            var InstrArcimId=ids.join(',')
                            if (InstrArcimId==""){
	                            editRow2 = undefined;
				                AddeditRow2=undefined;
				                oPInstrArcimDataGrid.datagrid("rejectChanges");
				                oPInstrArcimDataGrid.datagrid("unselectAll");
				                return;
	                        }
                            var value=$.m({
								 ClassName:"DHCDoc.DHCDocConfig.InstrArcim",
								 MethodName:"DeleteOPInstrArcim",
								 InstrArcimId:InstrArcimId
							},false);
							if(value=="0"){
								oPInstrArcimDataGrid.datagrid('load');
	           					oPInstrArcimDataGrid.datagrid('unselectAll');
	           					$.messager.popover({msg: '删除成功!',type:'success'});
							}else{
								$.messager.alert('提示',"删除失败:"+value);
								return;
							}
							editRow2 = undefined;
							AddeditRow2=undefined;
                        }
                    });
                } else {
                    $.messager.alert("提示", "请选择要删除的行");
                }
	         
            }
        },{
            text: '保存',
            iconCls: 'icon-save',
            handler: function() {
                //保存时结束当前编辑的行，自动触发onAfterEdit事件如果要与后台交互可将数据通过Ajax提交后台
              var rows = instrDataGrid.datagrid("getSelections");
                //选择要删除的行  
               if (rows.length > 0)
               { 
       				var ids = [];
                    for (var i = 0; i < rows.length; i++) {
                        ids.push(rows[i].InstrRowID);
                    }
                    //将选择到的行存入数组并用,分隔转换成字符串，
                    //本例只是前台操作没有与数据库进行交互所以此处只是弹出要传入后台的id
                    //console.info(ids);
                    var InstrRowId=ids.join(',')
	                if (editRow2 != undefined)
	                {
						if(InstrRowId=="") return false;
						var ArcimSelRow=oPInstrArcimDataGrid.datagrid("selectRow",editRow2).datagrid("getSelected"); 
						var InstrArcimId=ArcimSelRow["InstrArcimId"];
						if (InstrArcimId.indexOf("&")!=-1){
							//var selInstrRowID=InstrArcimId.split("&")[0];
							var curEditRow=editRow2
							var ArcimId=InstrArcimId.split("&")[1];
						}else{
							var curEditRow="";
							var ArcimId=InstrArcimId;
						}
						if (AddeditRow2==0){
							var curEditRow="";
						}
						if ((ArcimId=="")||(ArcimId==undefined)){
							$.messager.alert({title:"提示",msg:"请选择医嘱项!"});
	                        return false;
						}
	                	var editors = oPInstrArcimDataGrid.datagrid('getEditors', editRow2); 
						//var ArcimId =  editors[0].target.combobox('getValue');
						var ByDay =  editors[2].target.is(':checked');
						var InfusionFeeFlag =  editors[3].target.is(':checked');
						if (ByDay) ByDayVal=1;
						else ByDayVal=0;
						if (InfusionFeeFlag) InfusionFeeFlagVal=1;
						else InfusionFeeFlagVal=0;
						var Hospital="";
						if ($("#Check_UseHospSepInstrArcim").is(":checked")) {
							Hospital=$HUI.combogrid('#_HospList').getValue();
							if(Hospital==""){
								$.messager.alert({title:"提示",msg:"请选择医院"});
	                            return false;							
							}
						}
						if(Hospital!="") InstrRowId=InstrRowId+"||"+Hospital;
						var Qty=$.trim(editors[4].target.val());
						if (Qty!=""){
							var r = /^\+?[1-9][0-9]*$/;
							if(!r.test(Qty)){
								$.messager.alert('提示',"数量只能为正整数!");
								return false;
							}
						}
						var LOCRowId=ArcimSelRow.LocDr; //editors[3].target.combobox('getValue');
						if (LOCRowId==undefined) LOCRowId="";
						//console.info(InstrRowId+"^"+ArcimId+"^"+ByDayVal+"^"+InfusionFeeFlagVal);
						var value=$.m({
							 ClassName:"DHCDoc.DHCDocConfig.InstrArcim",
							 MethodName:"SaveOPInstrArcim",
							 InstrRowId:InstrRowId,
							 ArcimId:ArcimId,
							 ByDay:ByDayVal,
							 InfusionFeeFlag:InfusionFeeFlagVal,
							 LocRowId:session['LOGON.CTLOCID'],
							 curEditRow:curEditRow,
							 UseLocRowId:LOCRowId,
							 Qty:Qty
						},false);
						if(value=="0"){
							oPInstrArcimDataGrid.datagrid("endEdit", editRow2);
                			editRow2 = undefined;
							oPInstrArcimDataGrid.datagrid('load');
           					oPInstrArcimDataGrid.datagrid('unselectAll');
           					//$.messager.alert({title:"提示",msg:"保存成功"});           					
						}else{
							if(value=="101") value="项目重复,不能添加"
							if(value=="-2") value="请在下拉框中选择有效的医嘱项!"
							$.messager.alert('提示',"保存失败:"+value);
							return false;
						}
						editRow2 = undefined;
						AddeditRow2=undefined;
	            	}
	            
	             }else{
		            $.messager.alert("提示", "请选择一个要维护的用法"); 
		         }
            }
        },{
            text: '取消编辑',
            iconCls: 'icon-redo',
            handler: function() {
                //取消当前编辑行把当前编辑行罢undefined回滚改变的数据,取消选择的行
                editRow2 = undefined;
                AddeditRow2=undefined;
                oPInstrArcimDataGrid.datagrid("rejectChanges");
                oPInstrArcimDataGrid.datagrid("unselectAll");
            }
        },'-',{
	       text: '例外的医嘱类型',
            iconCls: 'icon-edit',
            handler: function() {
                ExcludePrior('OInstrAutoLinkOrdExcludePrior');
            } 
	    }];
    var oPInstrArcimColumns=[[    
        			{ field: 'ARCIMDesc', title: '医嘱项名称',  width: 120, 
        			  editor:{
		                         type:'combogrid',
		                         options:{
		                             required: true,
		                             panelWidth:450,
									 panelHeight:350,
		                             idField:'ArcimRowID',
		                             textField:'ArcimDesc',
		                            value:'',//缺省值 
		                            mode:'remote',
									pagination : true,//是否分页   
									rownumbers:true,//序号   
									collapsible:false,//是否可折叠的   
									fit: true,//自动大小   
									pageSize: 10,//每页显示的记录条数，默认为10   
									pageList: [10],//可以设置每页记录条数的列表  
		                            url:$URL+"?ClassName=DHCDoc.DHCDocConfig.ArcItemConfig&QueryName=FindAllItem",
		                            columns:[[
		                                {field:'ArcimDesc',title:'名称',width:400,sortable:true},
					                    {field:'ArcimRowID',title:'ID',width:120,sortable:true},
					                    {field:'selected',title:'ID',width:120,sortable:true,hidden:true}
		                             ]],
									onSelect : function(rowIndex, rowData) {
										var ArcimSelRow=oPInstrArcimDataGrid.datagrid("selectRow",editRow2).datagrid("getSelected"); 
										var oldInstrArcimId=ArcimSelRow.InstrArcimId;
										if ((oldInstrArcimId!="")&&(oldInstrArcimId!=undefined)){
										      ArcimSelRow.InstrArcimId=oldInstrArcimId.split("&")[0]+"&"+rowData.ArcimRowID;
										}else{
											  ArcimSelRow.InstrArcimId=rowData.ArcimRowID;
									    }
									},
									onBeforeLoad:function(param){
						                 var desc=param['q'];
						                 param = $.extend(param,{Alias:param["q"],HospId:$HUI.combogrid('#_HospList').getValue()});
						             }
                        		}
		        			  }
        			},
        			{ field: 'LocDesc', title: '开单科室', width: 120,
						editor :{  
							type:'combobox',  
							options:{
								url:$URL+"?ClassName=DHCDoc.DHCDocConfig.CNMedCode&QueryName=FindLoc&Type=O^E&rows=99999&HospId="+$HUI.combogrid('#_HospList').getValue(),
								valueField:'LocID',
								textField:'LocDesc',
								required:false,
								onBeforeLoad:function(param){
					                 param = $.extend(param,{HospId:$HUI.combogrid('#_HospList').getValue()});
					             },
								onSelect:function(record){
									var ArcimSelRow=oPInstrArcimDataGrid.datagrid("selectRow",editRow2).datagrid("getSelected"); 
									ArcimSelRow.LocDr=record.LocID;
								},onChange:function(newValue,oldValue){
									if (editRow2!=undefined){
										var ArcimSelRow=oPInstrArcimDataGrid.datagrid("selectRow",editRow2).datagrid("getSelected"); 
										if (newValue=="") ArcimSelRow.LocDr="";
								    }
								},
								loadFilter:function(data){
									return data['rows'];
							    },
							    filter: function(q, row){
									var opts = $(this).combobox('options');
									return row[opts.textField].toUpperCase().indexOf(q.toUpperCase()) >= 0;
								}

							  }
     					  }
										   
					},
					{
                      field : 'ByDay',title : '按天绑定',
                           editor : {
                                type : 'icheckbox',
                                options : {
                                    on : 'Y',
                                    off : '',
                                    onCheckChange:function(e,value){
	                                    if (value){
											var InfusionFeeFlagObj = oPInstrArcimDataGrid.datagrid("getEditor",{index:editRow2,field:'InfusionFeeFlag'});
											if (InfusionFeeFlagObj) $(InfusionFeeFlagObj.target).checkbox('uncheck');
		                                }
	                                }
                                }
                            }
                     },
                     {
                      field : 'InfusionFeeFlag',title : '按当次输液最大次数收输液费(输液次数必须)',
                           editor : {
                                type : 'icheckbox',
                                options : {
                                    on : 'Y',
                                    off : '',
                                    onCheckChange:function(e,value){
	                                    if (value){
		                                    var ByDayObj = oPInstrArcimDataGrid.datagrid("getEditor",{index:editRow2,field:'ByDay'});
											if (ByDayObj) $(ByDayObj.target).checkbox('uncheck')
		                                }
	                                }
                                }
                            }
                     },
                     { field: 'Qty', title: '数量', width: 50,
					  editor : {type : 'text',options : {}}
					 },
					{ field: 'InstrArcimId', title: 'InstrArcimId',hidden:true},
					{ field: 'LocDr', title: '开单科室',  width: 40,hidden: true}   
    			 ]];
	oPInstrArcimDataGrid=$("#tabOPInstrArcimList").datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		url:$URL+"?ClassName=DHCDoc.DHCDocConfig.InstrArcim&QueryName=FindOPInstrArcim",
		loadMsg : '加载中..',  
		pagination : true,  //
		rownumbers : true,  //
		idField:"InstrArcimId",
		pageSize:15,
		pageList : [15,50,100,200],
		columns :oPInstrArcimColumns,
    	toolbar :oPInstrArcimToolBar,
		onDblClickRow:function(rowIndex, rowData){ 
			//PTRowid=rowData.PTRowid 
            if (editRow2 != undefined) {
				$.messager.alert("提示", "有正在编辑的行，请先点击保存", "error");
		        return false;
			}
			oPInstrArcimDataGrid.datagrid("beginEdit", rowIndex);
			editRow2=rowIndex
			/*var ByDayObj = $(this).datagrid("getEditor",{index:rowIndex,field:'ByDay'});
			var InfusionFeeFlagObj = $(this).datagrid("getEditor",{index:rowIndex,field:'InfusionFeeFlag'});
			ByDayObj.target.change(function(){
				if(ByDayObj.target.is(':checked')) {
					InfusionFeeFlagObj.target.attr("checked",false)
				}
			})
			InfusionFeeFlagObj.target.change(function(){
				if(InfusionFeeFlagObj.target.is(':checked')) {
					ByDayObj.target.attr("checked",false)
				}
			})*/
	    },onBeforeLoad:function(param){
		    AddeditRow2=undefined;
		    editRow2=undefined;
		    if (oPInstrArcimDataGrid)  oPInstrArcimDataGrid.datagrid("unselectAll").datagrid("rejectChanges");
             var InstrRowId=param['InstrRowId'];
             var Hospital=$HUI.combogrid('#_HospList').getValue(); 
			/*if ($("#Check_UseHospSepInstrArcim").is(":checked")) {
				Hospital=$HUI.combogrid('#_HospList').getValue();
			}*/
             param = $.extend(param,{InstrRowId:InstrRowId,Hospital:Hospital});
         }
	});
	//-------------住院关联医嘱代码---------------
	var iPInstrArcimToolBar = [{
            text: '增加',
            iconCls: 'icon-add',
            handler: function() { //添加列表的操作按钮添加,修改,删除等
			    editRow3 = undefined;
                iPInstrArcimDataGrid.datagrid("rejectChanges");
                iPInstrArcimDataGrid.datagrid("unselectAll");
                if (editRow3 != undefined) {
                    iPInstrArcimDataGrid.datagrid("endEdit", editRow3);
                    return;
                }else{
	                 //添加时如果没有正在编辑的行，则在datagrid的第一行插入一行
                    iPInstrArcimDataGrid.datagrid("insertRow", {
                        index: 0,
                        // index start with 0
                        row: {

						}
                    });
                    //将新插入的那一行开户编辑状态
                    iPInstrArcimDataGrid.datagrid("beginEdit", 0);
                    //cureItemDataGrid.datagrid('addEditor',LocDescEdit);
                    //给当前编辑的行赋值
                    editRow3 = 0;
                    AddeditRow3=0;
                    /*var ByDayObj = iPInstrArcimDataGrid.datagrid("getEditor",{index:editRow3,field:'ByDay'});
					var InfusionFeeFlagObj = iPInstrArcimDataGrid.datagrid("getEditor",{index:editRow3,field:'InfusionFeeFlag'});
					ByDayObj.target.change(function(){
						if(ByDayObj.target.is(':checked')) {
							InfusionFeeFlagObj.target.attr("checked",false)
						}
					})
					InfusionFeeFlagObj.target.change(function(){
						if(InfusionFeeFlagObj.target.is(':checked')) {
							ByDayObj.target.attr("checked",false)
						}
					})*/
                }
              
            }
        },{
            text: '删除',
            iconCls: 'icon-cancel',
            handler: function() {
                //删除时先获取选择行
                var rows = iPInstrArcimDataGrid.datagrid("getSelections");
                //选择要删除的行
                if (rows.length > 0) {
                    $.messager.confirm("提示", "你确定要删除吗?",
                    function(r) {
                        if (r) {
                            var ids = [];
                            for (var i = 0; i < rows.length; i++) {
                                ids.push(rows[i].InstrArcimId);
                            }
                            //将选择到的行存入数组并用,分隔转换成字符串，
                            //本例只是前台操作没有与数据库进行交互所以此处只是弹出要传入后台的id
                            //console.info(ids);
                            var InstrArcimId=ids.join(',');
                            if (InstrArcimId==""){
	                            editRow3 = undefined;
				                AddeditRow3=undefined;
				                iPInstrArcimDataGrid.datagrid("rejectChanges");
				                iPInstrArcimDataGrid.datagrid("unselectAll");
				                return;
	                        }
                            var value=$.m({
								 ClassName:"DHCDoc.DHCDocConfig.InstrArcim",
								 MethodName:"DeleteIPInstrArcim",
								 InstrArcimId:InstrArcimId
							},false);
							if(value=="0"){
								iPInstrArcimDataGrid.datagrid('load');
	           					iPInstrArcimDataGrid.datagrid('unselectAll');
	           					$.messager.popover({msg: '删除成功!',type:'success'});
							}else{
								$.messager.alert('提示',"删除失败:"+value);
								return;
							}
							editRow3 = undefined;
							AddeditRow3=undefined;
                        }
                    });
                } else {
                    $.messager.alert("提示", "请选择要删除的行");
                }
            }
        },{
            text: '保存',
            iconCls: 'icon-save',
            handler: function() {
	            var rows = instrDataGrid.datagrid("getSelections");
                //选择要删除的行  
               if (rows.length > 0)
               { 
       				var ids = [];
                    for (var i = 0; i < rows.length; i++) {
                        ids.push(rows[i].InstrRowID);
                    }
                    //将选择到的行存入数组并用,分隔转换成字符串，
                    //本例只是前台操作没有与数据库进行交互所以此处只是弹出要传入后台的id
                    //console.info(ids);
                    var InstrRowId=ids.join(',')
	                if (editRow3 != undefined)
	                {
						if(InstrRowId=="") return false;
						var ArcimSelRow=iPInstrArcimDataGrid.datagrid("selectRow",editRow3).datagrid("getSelected");
						var InstrArcimId=ArcimSelRow["InstrArcimId"];
						if ((InstrArcimId!=undefined)&&(InstrArcimId.indexOf("&")!=-1)){
							//var selInstrRowID=InstrArcimId.split("&")[0];
							var curEditRow=editRow3
							var ArcimId=InstrArcimId.split("&")[1];
						}else{
							var curEditRow="";
							var ArcimId=InstrArcimId;
						}
						if (AddeditRow3==0){
							var curEditRow="";
						}
						if ((ArcimId=="")||(ArcimId==undefined)){
							$.messager.alert('提示',"请选择医嘱项!");
	                        return false;
						} 
	                	var editors = iPInstrArcimDataGrid.datagrid('getEditors', editRow3);      
						//var ArcimId =  editors[0].target.combobox('getValue');
						var ByDay =  editors[2].target.is(':checked');
						var InfusionFeeFlag =  editors[3].target.is(':checked');
						if (ByDay) ByDayVal=1;
						else ByDayVal=0;
						if (InfusionFeeFlag) InfusionFeeFlagVal=1;
						else InfusionFeeFlagVal=0;
						var Hospital="";
						if ($("#Check_UseHospSepInstrArcim").is(":checked")) {
							Hospital=$HUI.combogrid('#_HospList').getValue();
							if(Hospital==""){
								$.messager.alert('提示',"请选择医院");
	                            return false;							
							}
						}
						var LOCRowId=ArcimSelRow.LocDr; //editors[3].target.combobox('getValue');
						if (LOCRowId==undefined) LOCRowId="";
						if(Hospital!="") InstrRowId=InstrRowId+"||"+Hospital;
						var Qty = $.trim(editors[4].target.val());
						if (Qty!=""){
							var r = /^\+?[1-9][0-9]*$/;
							if(!r.test(Qty)){
								$.messager.alert('提示',"数量只能为正整数!");
								return false;
							}
						}
						//console.info("iPInstrArcimDataGrid:"+InstrRowId+"^"+ArcimId+"^"+ByDayVal+"^"+InfusionFeeFlagVal);
						var value=$.m({
							 ClassName:"DHCDoc.DHCDocConfig.InstrArcim",
							 MethodName:"SaveIPInstrArcim",
							 InstrRowId:InstrRowId,
							 ArcimId:ArcimId,
							 ByDay:ByDayVal,
							 InfusionFeeFlag:InfusionFeeFlagVal,
							 LocRowId:session['LOGON.CTLOCID'],
							 curEditRow:curEditRow,
							 UseLocRowId:LOCRowId,
							 Qty:Qty
						},false);
						if(value=="0"){
							iPInstrArcimDataGrid.datagrid("endEdit", editRow3);
                			editRow3 = undefined;
							iPInstrArcimDataGrid.datagrid('load');
           					iPInstrArcimDataGrid.datagrid('unselectAll');
           					//$.messager.alert({title:"提示",msg:"保存成功"});           					
						}else{
							if(value=="101") value="项目重复,不能添加"
							if(value=="-2") value="请在下拉框中选择有效的医嘱项!"
							$.messager.alert('提示',"保存失败:"+value);
							return false;
						}
						editRow3 = undefined;
						AddeditRow3=undefined;
	            	}
	             }else{
		            $.messager.alert("提示", "请选择一个要维护的用法"); 
		         }
             }
        },{
            text: '取消编辑',
            iconCls: 'icon-redo',
            handler: function() {
                //取消当前编辑行把当前编辑行罢undefined回滚改变的数据,取消选择的行
                editRow3 = undefined;
                AddeditRow3=undefined;
                iPInstrArcimDataGrid.datagrid("rejectChanges");
                iPInstrArcimDataGrid.datagrid("unselectAll");
            }
        },'-',{
	       text: '例外的医嘱类型',
            iconCls: 'icon-edit',
            handler: function() {
                ExcludePrior('IInstrAutoLinkOrdExcludePrior');
            } 
	    }];
    var iPInstrArcimColumns=[[    
        			{ field: 'ARCIMDesc', title: '医嘱项名称',
        			  editor:{
		                         type:'combogrid',
		                         options:{
		                             required: true,
		                             panelWidth:450,
									 panelHeight:350,
		                             idField:'ArcimRowID',
		                             textField:'ArcimDesc',
		                            value:'',//缺省值 
		                            mode:'remote',
									pagination : true,//是否分页   
									rownumbers:true,//序号   
									collapsible:false,//是否可折叠的   
									fit: true,//自动大小   
									pageSize: 10,//每页显示的记录条数，默认为10   
									pageList: [10],//可以设置每页记录条数的列表  
		                            url:$URL+"?ClassName=DHCDoc.DHCDocConfig.ArcItemConfig&QueryName=FindAllItem",
		                            columns:[[
		                                {field:'ArcimDesc',title:'名称',width:400,sortable:true},
					                    {field:'ArcimRowID',title:'ID',width:120,sortable:true},
					                    {field:'selected',title:'ID',width:120,sortable:true,hidden:true}
		                             ]],
                        			onSelect : function(rowIndex, rowData) {
	                        			var ArcimSelRow=iPInstrArcimDataGrid.datagrid("selectRow",editRow3).datagrid("getSelected"); 
										var oldInstrArcimId=ArcimSelRow.InstrArcimId;
										if ((oldInstrArcimId!="")&&(oldInstrArcimId!=undefined)){
										      ArcimSelRow.InstrArcimId=oldInstrArcimId.split("&")[0]+"&"+rowData.ArcimRowID;
										}else{
											  ArcimSelRow.InstrArcimId=rowData.ArcimRowID;
									    }
									},
									onBeforeLoad:function(param){
						                 var desc=param['q'];
						                 param = $.extend(param,{Alias:param["q"],HospId:$HUI.combogrid('#_HospList').getValue()});
						            }
                        		}
		        			  }
        			},
        			{ field: 'LocDesc', title: '开单科室', width: 100,
						editor :{  
							type:'combobox',  
							options:{
								url:$URL+"?ClassName=DHCDoc.DHCDocConfig.CNMedCode&QueryName=FindLoc&Type=I&rows=99999&HospId="+$HUI.combogrid('#_HospList').getValue(),
								valueField:'LocID',
								textField:'LocDesc',
								required:false,
								onBeforeLoad:function(param){
					                 param = $.extend(param,{HospId:$HUI.combogrid('#_HospList').getValue()});
					             },
								onSelect:function(record){
									var ArcimSelRow=iPInstrArcimDataGrid.datagrid("selectRow",editRow3).datagrid("getSelected"); 
									ArcimSelRow.LocDr=record.LocID;
								},onChange:function(newValue,oldValue){
									if (editRow3!=undefined){
										var ArcimSelRow=iPInstrArcimDataGrid.datagrid("selectRow",editRow3).datagrid("getSelected"); 
										if (newValue=="") ArcimSelRow.LocDr="";
								    }
								},
								loadFilter:function(data){
									return data['rows'];
								},
							    filter: function(q, row){
									var opts = $(this).combobox('options');
									return row[opts.textField].toUpperCase().indexOf(q.toUpperCase()) >= 0;
								}
							  }
     					  }
										   
					},
					{
                      field : 'ByDay',title : '按天绑定',
                           editor : {
                                type : 'icheckbox',
                                options : {
                                    on : 'Y',
                                    off : '',
                                    onCheckChange:function(e,value){
	                                    if (value){
		                                    var InfusionFeeFlagObj = iPInstrArcimDataGrid.datagrid("getEditor",{index:editRow3,field:'InfusionFeeFlag'});
											if (InfusionFeeFlagObj) $(InfusionFeeFlagObj.target).checkbox('uncheck')
		                                }
	                                }
                                }
                            }
                     },
                     {
                      field : 'InfusionFeeFlag',title : '按当次输液最大次数收输液费(输液次数必须)',
                           editor : {
                                type : 'icheckbox',
                                options : {
                                    on : 'Y',
                                    off : '',
                                    onCheckChange:function(e,value){
	                                    if (value){
		                                    var ByDayObj = iPInstrArcimDataGrid.datagrid("getEditor",{index:editRow3,field:'ByDay'});
											if (ByDayObj) $(ByDayObj.target).checkbox('uncheck')
		                                }
	                                }
                                }
                            }
                     },
                     { field: 'Qty', title: '数量', width: 50,
					  editor : {type : 'text',options : {}}
					},
					{ field: 'InstrArcimId', title: 'InstrArcimId',  align: 'center', sortable: false, resizable: true,hidden:true} ,
					
					{ field: 'LocDr', title: '开单科室',  width: 40,align: 'center', sortable: false, resizable: true,hidden: true
					}    
    			 ]];
	iPInstrArcimDataGrid=$("#tabIPInstrArcimList").datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		url:$URL+"?ClassName=DHCDoc.DHCDocConfig.InstrArcim&QueryName=FindIPInstrArcim",
		loadMsg : '加载中..',  
		pagination : true,  //
		rownumbers : true,  //
		idField:"ArcimId",
		pageSize:15,
		pageList : [15,50,100,200],
		columns :iPInstrArcimColumns,
    	toolbar :iPInstrArcimToolBar,
		onDblClickRow:function(rowIndex, rowData){ 
            if (editRow3 != undefined) {
				$.messager.alert("提示", "有正在编辑的行，请先点击保存");
		        return false;
			}
			iPInstrArcimDataGrid.datagrid("beginEdit", rowIndex);
			editRow3=rowIndex;
			//var eds = $(selector).datagrid("getEditors",rowIndex);
			/*var ByDayObj = $(this).datagrid("getEditor",{index:rowIndex,field:'ByDay'});
			var InfusionFeeFlagObj = $(this).datagrid("getEditor",{index:rowIndex,field:'InfusionFeeFlag'});
			ByDayObj.target.change(function(){
				if(ByDayObj.target.is(':checked')) {
					InfusionFeeFlagObj.target.attr("checked",false)
				}
			})
			InfusionFeeFlagObj.target.change(function(){
				if(InfusionFeeFlagObj.target.is(':checked')) {
					ByDayObj.target.attr("checked",false)
				}
			})*/
	    },
	    onBeforeLoad:function(param){
		    AddeditRow3=undefined;
		    editRow3=undefined;
		    if (iPInstrArcimDataGrid)  iPInstrArcimDataGrid.datagrid("unselectAll").datagrid("rejectChanges");
             var InstrRowId=param['InstrRowId'];
             var Hospital="" 
			if ($("#Check_UseHospSepInstrArcim").is(":checked")) {
					Hospital=$HUI.combogrid('#_HospList').getValue();
			}
             param = $.extend(param,{InstrRowId:InstrRowId,Hospital:Hospital});
         }
	});
	//-------------手动选择关联医嘱 门诊关联医嘱代码---------------
	/*var oPInstrArcimSelToolBar = [{
            text: '添加',
            iconCls: 'icon-add',
            handler: function() { //添加列表的操作按钮添加,修改,删除等
			    editRow4 = undefined;
                oPInstrArcimSelDataGrid.datagrid("rejectChanges");
                oPInstrArcimSelDataGrid.datagrid("unselectAll");
                if (editRow4 != undefined) {
                    oPInstrArcimSelDataGrid.datagrid("endEdit", editRow4);
                    return;
                }else{
	                 //添加时如果没有正在编辑的行，则在datagrid的第一行插入一行
                    oPInstrArcimSelDataGrid.datagrid("insertRow", {
                        index: 0,
                        // index start with 0
                        row: {

						}
                    });
                    //将新插入的那一行开户编辑状态
                    oPInstrArcimSelDataGrid.datagrid("beginEdit", 0);
                    //cureItemDataGrid.datagrid('addEditor',LocDescEdit);
                    //给当前编辑的行赋值
                    editRow4 = 0;
                    AddeditRow4=0;
                }
              
            }
        },
        '-', {
            text: '删除',
            iconCls: 'icon-remove',
            handler: function() {
                //删除时先获取选择行
                var rows = oPInstrArcimSelDataGrid.datagrid("getSelections");
                //选择要删除的行
                if (rows.length > 0) {
                    $.messager.confirm("提示", "你确定要删除吗?",
                    function(r) {
                        if (r) {
                            var ids = [];
                            for (var i = 0; i < rows.length; i++) {
                                ids.push(rows[i].InstrArcimId);
                            }
                            //将选择到的行存入数组并用,分隔转换成字符串，
                            //本例只是前台操作没有与数据库进行交互所以此处只是弹出要传入后台的id
                            //console.info(ids);
                            var InstrArcimId=ids.join(',')
                            //console.info("删除:"+InstrArcimId)
                            $.dhc.util.runServerMethod("DHCDoc.DHCDocConfig.InstrArcim","DeleteOPInstrArcimSel","false",function testget(value){
						if(value=="0"){
							oPInstrArcimSelDataGrid.datagrid('load');
           					oPInstrArcimSelDataGrid.datagrid('unselectAll');
           					$.messager.show({title:"提示",msg:"删除成功"});
						}else{
							$.messager.alert('提示',"删除失败:"+value);
						}
						editRow4 = undefined;
						AddeditRow4= undefined;
						},"","",InstrArcimId);
                        }
                    });
                } else {
                    $.messager.alert("提示", "请选择要删除的行", "error");
                }
	         
            }
        },
        '-', {
            text: '保存',
            iconCls: 'icon-save',
            handler: function() {
                //保存时结束当前编辑的行，自动触发onAfterEdit事件如果要与后台交互可将数据通过Ajax提交后台
               var rows = instrDataGrid.datagrid("getSelections");
                //选择要删除的行  
               if (rows.length > 0)
               { 
       				var ids = [];
                    for (var i = 0; i < rows.length; i++) {
                        ids.push(rows[i].InstrRowID);
                    }
                    //将选择到的行存入数组并用,分隔转换成字符串，
                    //本例只是前台操作没有与数据库进行交互所以此处只是弹出要传入后台的id
                    //console.info(ids);
                    var InstrRowId=ids.join(',')
	                if (editRow4 != undefined)
	                {
						if(InstrRowId=="") return false;
	                	var editors = oPInstrArcimSelDataGrid.datagrid('getEditors', editRow4);  
	                	var ArcimSelRow=oPInstrArcimSelDataGrid.datagrid("selectRow",editRow4).datagrid("getSelected"); 
						var InstrArcimId=ArcimSelRow["InstrArcimId"];
						if (InstrArcimId.indexOf("&")!=-1){
							//var selInstrRowID=InstrArcimId.split("&")[0];
							var curEditRow=editRow4
							var ArcimId=InstrArcimId.split("&")[1];
						}else{
							var curEditRow="";
							var ArcimId=InstrArcimId;
						}
						if (AddeditRow4==0){
							var curEditRow="";
						}
						if ((ArcimId=="")||(ArcimId==undefined)){
							$.messager.alert({title:"提示",msg:"请选择医嘱项!"});
	                        return false;
						}    
						//var ArcimId =  editors[0].target.combobox('getValue');
						var Hospital="";
						if ($("#Check_UseHospSepInstrArcim").is(":checked")) {
							Hospital=$HUI.combogrid('#_HospList').getValue();
							if(Hospital==""){
								$.messager.alert({title:"提示",msg:"请选择医院"});
	                            return false;							
							}
						}
						if(Hospital!="") InstrRowId=InstrRowId+"||"+Hospital;
						var LOCRowId=ArcimSelRow.LocDr; //editors[3].target.combobox('getValue');
						if (LOCRowId==undefined) LOCRowId="";
						//console.info(InstrRowId+"^"+ArcimId);
	                	$.dhc.util.runServerMethod("DHCDoc.DHCDocConfig.InstrArcim","SaveOPInstrArcimSel","false",function testget(value){
		                
							if(value=="0"){
								oPInstrArcimSelDataGrid.datagrid("endEdit", editRow4);
	                			editRow4 = undefined;
								oPInstrArcimSelDataGrid.datagrid('load');
	           					oPInstrArcimSelDataGrid.datagrid('unselectAll');
	           					//$.messager.alert({title:"提示",msg:"保存成功"});           					
							}else{
								if(value=="101") value="项目重复,不能添加"
								if(value=="-2") value="请在下拉框中选择有效的医嘱项!"
								$.messager.alert('提示',"保存失败:"+value);
								return false;
							}
							editRow4 = undefined;
							AddeditRow4=undefined;
							},"","",InstrRowId,ArcimId,PUBLIC_CONSTANT.SESSION.GCTLOC_ROWID,curEditRow,LOCRowId);
	            	}
	            
	             }else{
		            $.messager.alert("提示", "请选择一个要维护的用法", "error"); 
		         }
            }
        },
        '-', {
            text: '取消编辑',
            iconCls: 'icon-redo',
            handler: function() {
                //取消当前编辑行把当前编辑行罢undefined回滚改变的数据,取消选择的行
                editRow4 = undefined;
                AddeditRow4= undefined;
                oPInstrArcimSelDataGrid.datagrid("rejectChanges");
                oPInstrArcimSelDataGrid.datagrid("unselectAll");
            }
        }];
    var oPInstrArcimSelColumns=[[    
        			{ field: 'ARCIMDesc', title: '医嘱项名称', width: 100, align: 'center', sortable: false, resizable: true,
        			  editor:{
		                         type:'combogrid',
		                         options:{
		                             required: true,
		                             panelWidth:450,
									 panelHeight:350,
		                             idField:'ArcimRowID',
		                             textField:'ArcimDesc',
		                            value:'',//缺省值 
		                            mode:'remote',
									pagination : true,//是否分页   
									rownumbers:true,//序号   
									collapsible:false,//是否可折叠的   
									fit: true,//自动大小   
									pageSize: 10,//每页显示的记录条数，默认为10   
									pageList: [10],//可以设置每页记录条数的列表  
		                            url:PUBLIC_CONSTANT.URL.QUERY_GRID_URL,
		                            columns:[[
		                                {field:'ArcimDesc',title:'名称',width:400,sortable:true},
					                    {field:'ArcimRowID',title:'ID',width:120,sortable:true},
					                    {field:'selected',title:'ID',width:120,sortable:true,hidden:true}
		                             ]],
									 keyHandler:{
										up: function () {
							                //取得选中行
							                var selected = $(this).combogrid('grid').datagrid('getSelected');
							                if (selected) {
							                    //取得选中行的rowIndex
							                    var index = $(this).combogrid('grid').datagrid('getRowIndex', selected);
							                    //向上移动到第一行为止
							                    if (index > 0) {
							                        $(this).combogrid('grid').datagrid('selectRow', index - 1);
							                    }
							                } else {
							                    var rows = $(this).combogrid('grid').datagrid('getRows');
							                    $(this).combogrid('grid').datagrid('selectRow', rows.length - 1);
							                }
							             },
							             down: function () {
							               //取得选中行
							                var selected = $(this).combogrid('grid').datagrid('getSelected');
							                if (selected) {
							                    //取得选中行的rowIndex
							                    var index = $(this).combogrid('grid').datagrid('getRowIndex', selected);
							                    //向下移动到当页最后一行为止
							                    if (index < $(this).combogrid('grid').datagrid('getData').rows.length - 1) {
							                        $(this).combogrid('grid').datagrid('selectRow', index + 1);
							                    }
							                } else {
							                    $(this).combogrid('grid').datagrid('selectRow', 0);
							                }
							            },
										left: function () {
											return false;
							            },
										right: function () {
											return false;
							            },            
										enter: function () { 
										  //文本框的内容为选中行的的字段内容
							                var selected = $(this).combogrid('grid').datagrid('getSelected');  
										    if (selected) { 
										      $(this).combogrid("options").value=selected.ArcimDesc;
										      var ArcimSelRow=oPInstrArcimSelDataGrid.datagrid("selectRow",editRow4).datagrid("getSelected"); 
										      var oldInstrArcimId=ArcimSelRow.InstrArcimId;
										      if ((oldInstrArcimId!="")&&(oldInstrArcimId!=undefined)){
											      ArcimSelRow.InstrArcimId=oldInstrArcimId.split("&")[0]+"&"+selected.ArcimRowID;
											  }else{
												  ArcimSelRow.InstrArcimId=selected.ArcimRowID;
										      }
										    }
							                //选中后让下拉表格消失
							                $(this).combogrid('hidePanel');
											$(this).focus();
							            },
										 query:function(q){
											var object1=new Object();
											object1=$(this)
											if (this.AutoSearchTimeOut) {
												window.clearTimeout(this.AutoSearchTimeOut)
												this.AutoSearchTimeOut=window.setTimeout(function(){ LoadItemData(q,object1);},400); 
											}else{
												this.AutoSearchTimeOut=window.setTimeout(function(){ LoadItemData(q,object1);},400); 
											}
											$(this).combogrid("setValue",q);
										}
                        			},
                        			onSelect : function(rowIndex, rowData) {
	                        			var ArcimSelRow=oPInstrArcimSelDataGrid.datagrid("selectRow",editRow4).datagrid("getSelected"); 
										var oldInstrArcimId=ArcimSelRow.InstrArcimId;
										if ((oldInstrArcimId!="")&&(oldInstrArcimId!=undefined)){
										      ArcimSelRow.InstrArcimId=oldInstrArcimId.split("&")[0]+"&"+rowData.ArcimRowID;
										}else{
											  ArcimSelRow.InstrArcimId=rowData.ArcimRowID;
									    }
										
									}
                        		}
		        			  }
        			},
					{ field: 'InstrArcimId', title: 'InstrArcimId', width: 100, align: 'center', sortable: false, resizable: true,hidden:true},
					{ field: 'LocDesc', title: '开单科室', width: 100, align: 'center', sortable: false, resizable: true,
						editor :{  
							type:'combobox',  
							options:{
								url:PUBLIC_CONSTANT.URL.QUERY_COMBO_URL,
								valueField:'LocID',
								textField:'LocDesc',
								required:false,
								onBeforeLoad:function(param){
									param.ClassName = "DHCDoc.DHCDocConfig.CNMedCode";
									param.QueryName = "FindLoc";
									param.Arg1 ="O^E";
						            param.ArgCnt =1;
								},onSelect:function(record){
									var ArcimSelRow=oPInstrArcimSelDataGrid.datagrid("selectRow",editRow4).datagrid("getSelected"); 
									ArcimSelRow.LocDr=record.LocID;
								},onChange:function(newValue,oldValue){
									if (editRow4!=undefined){
										var ArcimSelRow=oPInstrArcimSelDataGrid.datagrid("selectRow",editRow4).datagrid("getSelected"); 
										if (newValue=="") ArcimSelRow.LocDr="";
								    }
								}
							  }
     					  }
										   
					},
					{ field: 'LocDr', title: '开单科室',  width: 40,align: 'center', sortable: false, resizable: true,hidden: true
					}     
    			 ]];
	oPInstrArcimSelDataGrid=$("#tabOPInstrArcimSelList").datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		url : PUBLIC_CONSTANT.URL.QUERY_GRID_URL,
		loadMsg : '加载中..',  
		pagination : true,  //
		rownumbers : true,  //
		idField:"InstrArcimId",
		pageList : [15,50,100,200],
		columns :oPInstrArcimSelColumns,
    	toolbar :oPInstrArcimSelToolBar,
		onSelect : function(rowIndex, rowData) {
		},
		onLoadSuccess:function(data){  
		},
		onClickRow:function(rowIndex, rowData){
		},onDblClickRow:function(rowIndex, rowData){ 
            if (editRow4 != undefined) {
				$.messager.alert("提示", "有正在编辑的行，请先点击保存", "error");
		        return false;
			}
			oPInstrArcimSelDataGrid.datagrid("beginEdit", rowIndex);
			editRow4=rowIndex
	    }
	});
	//-------------住院关联医嘱代码---------------
	var iPInstrArcimSelToolBar = [{
            text: '添加',
            iconCls: 'icon-add',
            handler: function() { //添加列表的操作按钮添加,修改,删除等
			    editRow5 = undefined;
                iPInstrArcimSelDataGrid.datagrid("rejectChanges");
                iPInstrArcimSelDataGrid.datagrid("unselectAll");
                if (editRow5 != undefined) {
                    iPInstrArcimSelDataGrid.datagrid("endEdit", editRow5);
                    return;
                }else{
	                 //添加时如果没有正在编辑的行，则在datagrid的第一行插入一行
                    iPInstrArcimSelDataGrid.datagrid("insertRow", {
                        index: 0,
                        // index start with 0
                        row: {

						}
                    });
                    //将新插入的那一行开户编辑状态
                    iPInstrArcimSelDataGrid.datagrid("beginEdit", 0);
                    //cureItemDataGrid.datagrid('addEditor',LocDescEdit);
                    //给当前编辑的行赋值
                    editRow5 = 0;
                    AddeditRow5=0;
                }
              
            }
        },
        '-', {
            text: '删除',
            iconCls: 'icon-remove',
            handler: function() {
                //删除时先获取选择行
                var rows = iPInstrArcimSelDataGrid.datagrid("getSelections");
                //选择要删除的行
                if (rows.length > 0) {
                    $.messager.confirm("提示", "你确定要删除吗?",
                    function(r) {
                        if (r) {
                            var ids = [];
                            for (var i = 0; i < rows.length; i++) {
                                ids.push(rows[i].InstrArcimId);
                            }
                            //将选择到的行存入数组并用,分隔转换成字符串，
                            //本例只是前台操作没有与数据库进行交互所以此处只是弹出要传入后台的id
                            //console.info(ids);
                            var InstrArcimId=ids.join(',')
                            //console.info("删除:"+InstrArcimId)
                            $.dhc.util.runServerMethod("DHCDoc.DHCDocConfig.InstrArcim","DeleteIPInstrArcimSel","false",function testget(value){
						if(value=="0"){
							iPInstrArcimSelDataGrid.datagrid('load');
           					iPInstrArcimSelDataGrid.datagrid('unselectAll');
           					$.messager.show({title:"提示",msg:"删除成功"});
						}else{
							$.messager.alert('提示',"删除失败:"+value);
						}
						editRow5 = undefined;
						AddeditRow5= undefined;
						},"","",InstrArcimId);
                        }
                    });
                } else {
                    $.messager.alert("提示", "请选择要删除的行", "error");
                }
            }
        },
        '-', {
            text: '保存',
            iconCls: 'icon-save',
            handler: function() {
	            var rows = instrDataGrid.datagrid("getSelections");
                //选择要删除的行  
               if (rows.length > 0)
               { 
               				var ids = [];
                            for (var i = 0; i < rows.length; i++) {
                                ids.push(rows[i].InstrRowID);
                            }
                            //将选择到的行存入数组并用,分隔转换成字符串，
                            //本例只是前台操作没有与数据库进行交互所以此处只是弹出要传入后台的id
                            //console.info(ids);
                            var InstrRowId=ids.join(',')
                if (editRow5 != undefined)
                {
					if(InstrRowId=="") return false;
                	var editors = iPInstrArcimSelDataGrid.datagrid('getEditors', editRow5);
                	var ArcimSelRow=iPInstrArcimSelDataGrid.datagrid("selectRow",editRow5).datagrid("getSelected"); 
					var InstrArcimId=ArcimSelRow["InstrArcimId"];
					if (InstrArcimId.indexOf("&")!=-1){
						//var selInstrRowID=InstrArcimId.split("&")[0];
						var curEditRow=editRow5
						var ArcimId=InstrArcimId.split("&")[1];
					}else{
						var curEditRow="";
						var ArcimId=InstrArcimId;
					}
					if (AddeditRow5==0){
						var curEditRow="";
					}
					if ((ArcimId=="")||(ArcimId==undefined)){
						$.messager.alert({title:"提示",msg:"请选择医嘱项!"});
                        return false;
					}      
					//var ArcimId =  editors[0].target.combobox('getValue');
					var Hospital="";
					if ($("#Check_UseHospSepInstrArcim").is(":checked")) {
						Hospital=$HUI.combogrid('#_HospList').getValue();
						if(Hospital==""){
							$.messager.alert({title:"提示",msg:"请选择医院"});
                            return false;							
						}
					}
					if(Hospital!="") InstrRowId=InstrRowId+"||"+Hospital;
					var LOCRowId=ArcimSelRow.LocDr; //editors[3].target.combobox('getValue');
						if (LOCRowId==undefined) LOCRowId="";
					//console.info(InstrRowId+"^"+ArcimId);
                	$.dhc.util.runServerMethod("DHCDoc.DHCDocConfig.InstrArcim","SaveIPInstrArcimSel","false",function testget(value){
	                
						if(value=="0"){
							iPInstrArcimSelDataGrid.datagrid("endEdit", editRow3);
                			editRow5 = undefined;
							iPInstrArcimSelDataGrid.datagrid('load');
           					iPInstrArcimSelDataGrid.datagrid('unselectAll');
           					//$.messager.alert({title:"提示",msg:"保存成功"});           					
						}else{
							if(value=="101") value="项目重复,不能添加"
							if(value=="-2") value="请在下拉框中选择有效的医嘱项!"
							$.messager.alert('提示',"保存失败:"+value);
							return false;
						}
						editRow5 = undefined;
						AddeditRow5=undefined;
						},"","",InstrRowId,ArcimId,PUBLIC_CONSTANT.SESSION.GCTLOC_ROWID,curEditRow,LOCRowId);
            	}
            
             }else{
	            $.messager.alert("提示", "请选择一个要维护的用法", "error"); 
	         }
             }
        },
        '-', {
            text: '取消编辑',
            iconCls: 'icon-redo',
            handler: function() {
                //取消当前编辑行把当前编辑行罢undefined回滚改变的数据,取消选择的行
                editRow5 = undefined;
                AddeditRow5= undefined;
                iPInstrArcimSelDataGrid.datagrid("rejectChanges");
                iPInstrArcimSelDataGrid.datagrid("unselectAll");
            }
        }];
    var iPInstrArcimSelColumns=[[    
        			{ field: 'ARCIMDesc', title: '医嘱项名称', width: 100, align: 'center', sortable: false, resizable: true,
        			  editor:{
		                         type:'combogrid',
		                         options:{
		                             required: true,
		                             panelWidth:450,
									 panelHeight:350,
		                             idField:'ArcimRowID',
		                             textField:'ArcimDesc',
		                            value:'',//缺省值 
		                            mode:'remote',
									pagination : true,//是否分页   
									rownumbers:true,//序号   
									collapsible:false,//是否可折叠的   
									fit: true,//自动大小   
									pageSize: 10,//每页显示的记录条数，默认为10   
									pageList: [10],//可以设置每页记录条数的列表  
		                            url:PUBLIC_CONSTANT.URL.QUERY_GRID_URL,
		                            columns:[[
		                                {field:'ArcimDesc',title:'名称',width:400,sortable:true},
					                    {field:'ArcimRowID',title:'ID',width:120,sortable:true},
					                    {field:'selected',title:'ID',width:120,sortable:true,hidden:true}
		                             ]],
									 keyHandler:{
										up: function () {
							                //取得选中行
							                var selected = $(this).combogrid('grid').datagrid('getSelected');
							                if (selected) {
							                    //取得选中行的rowIndex
							                    var index = $(this).combogrid('grid').datagrid('getRowIndex', selected);
							                    //向上移动到第一行为止
							                    if (index > 0) {
							                        $(this).combogrid('grid').datagrid('selectRow', index - 1);
							                    }
							                } else {
							                    var rows = $(this).combogrid('grid').datagrid('getRows');
							                    $(this).combogrid('grid').datagrid('selectRow', rows.length - 1);
							                }
							             },
							             down: function () {
							               //取得选中行
							                var selected = $(this).combogrid('grid').datagrid('getSelected');
							                if (selected) {
							                    //取得选中行的rowIndex
							                    var index = $(this).combogrid('grid').datagrid('getRowIndex', selected);
							                    //向下移动到当页最后一行为止
							                    if (index < $(this).combogrid('grid').datagrid('getData').rows.length - 1) {
							                        $(this).combogrid('grid').datagrid('selectRow', index + 1);
							                    }
							                } else {
							                    $(this).combogrid('grid').datagrid('selectRow', 0);
							                }
							            },
										left: function () {
											return false;
							            },
										right: function () {
											return false;
							            },            
										enter: function () { 
										  //文本框的内容为选中行的的字段内容
							                var selected = $(this).combogrid('grid').datagrid('getSelected');  
										    if (selected) { 
										      $(this).combogrid("options").value=selected.ArcimDesc;
										      var ArcimSelRow=iPInstrArcimSelDataGrid.datagrid("selectRow",editRow5).datagrid("getSelected"); 
										      var oldInstrArcimId=ArcimSelRow.InstrArcimId;
										      if ((oldInstrArcimId!="")&&(oldInstrArcimId!=undefined)){
											      ArcimSelRow.InstrArcimId=oldInstrArcimId.split("&")[0]+"&"+selected.ArcimRowID;
											  }else{
												  ArcimSelRow.InstrArcimId=selected.ArcimRowID;
										      }
										    }
							                //选中后让下拉表格消失
							                $(this).combogrid('hidePanel');
											$(this).focus();
							            },
										 query:function(q){
											var object1=new Object();
											object1=$(this)
											if (this.AutoSearchTimeOut) {
												window.clearTimeout(this.AutoSearchTimeOut)
												this.AutoSearchTimeOut=window.setTimeout(function(){ LoadItemData(q,object1);},400); 
											}else{
												this.AutoSearchTimeOut=window.setTimeout(function(){ LoadItemData(q,object1);},400); 
											}
											$(this).combogrid("setValue",q);
										}
                        			},
                        			onSelect : function(rowIndex, rowData) {
	                        			var ArcimSelRow=iPInstrArcimSelDataGrid.datagrid("selectRow",editRow5).datagrid("getSelected"); 
										var oldInstrArcimId=ArcimSelRow.InstrArcimId;
										if ((oldInstrArcimId!="")&&(oldInstrArcimId!=undefined)){
										      ArcimSelRow.InstrArcimId=oldInstrArcimId.split("&")[0]+"&"+rowData.ArcimRowID;
										}else{
											  ArcimSelRow.InstrArcimId=rowData.ArcimRowID;
									    }
									}
                        		}
		        			  }
        			},
					{ field: 'InstrArcimId', title: 'InstrArcimId', width: 100, align: 'center', sortable: false, resizable: true,hidden:true},
					{ field: 'LocDesc', title: '开单科室', width: 100, align: 'center', sortable: false, resizable: true,
						editor :{  
							type:'combobox',  
							options:{
								url:PUBLIC_CONSTANT.URL.QUERY_COMBO_URL,
								valueField:'LocID',
								textField:'LocDesc',
								required:false,
								onBeforeLoad:function(param){
									param.ClassName = "DHCDoc.DHCDocConfig.CNMedCode";
									param.QueryName = "FindLoc";
									param.Arg1 ="I";
						            param.ArgCnt =1;
								},onSelect:function(record){
									var ArcimSelRow=iPInstrArcimSelDataGrid.datagrid("selectRow",editRow5).datagrid("getSelected"); 
									ArcimSelRow.LocDr=record.LocID;
								},onChange:function(newValue,oldValue){
									if (editRow5!=undefined){
										var ArcimSelRow=iPInstrArcimSelDataGrid.datagrid("selectRow",editRow5).datagrid("getSelected"); 
										if (newValue=="") ArcimSelRow.LocDr="";
								    }
								}
							  }
     					  }
										   
					},
					{ field: 'LocDr', title: '开单科室',  width: 40,align: 'center', sortable: false, resizable: true,hidden: true
					} 
    			 ]];
	iPInstrArcimSelDataGrid=$("#tabIPInstrArcimSelList").datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		url : PUBLIC_CONSTANT.URL.QUERY_GRID_URL,
		loadMsg : '加载中..',  
		pagination : true,  //
		rownumbers : true,  //
		idField:"ArcimId",
		pageList : [15,50,100,200],
		columns :iPInstrArcimSelColumns,
    	toolbar :iPInstrArcimSelToolBar,
		onSelect : function(rowIndex, rowData) {
		},
		onLoadSuccess:function(data){  
		},
		onClickRow:function(rowIndex, rowData){
		},
		onDblClickRow:function(rowIndex, rowData){ 
            if (editRow5 != undefined) {
				$.messager.alert("提示", "有正在编辑的行，请先点击保存", "error");
		        return false;
			}
			iPInstrArcimSelDataGrid.datagrid("beginEdit", rowIndex);
			editRow5=rowIndex
	    }
	});*/
	$("#Check_UseHospSepInstrArcim").checkbox({
	   onCheckChange:function(e,value){
		   var UseHospSepInstrArcim=$("#Check_UseHospSepInstrArcim").checkbox('getValue')?1:0;
		   var str="UseHospSepInstrArcim"+String.fromCharCode(1)+UseHospSepInstrArcim;
		   var value=$.m({
			 ClassName:"web.DHCDocConfig",
			 MethodName:"SaveConfig",
			 Coninfo:str
		   },false);
		   var select = instrDataGrid.datagrid("getSelected");	  
	       if(select){
			   var InstrRowID=select.InstrRowID;
		       loadOPInstrArcimDataGrid(InstrRowID);
		       loadIPInstrArcimDataGrid(InstrRowID);
		       LoadSaveInstrProperty(InstrRowID);
		       //loadOPInstrArcimSelDataGrid(InstrRowID);
		       //loadIPInstrArcimSelDataGrid(InstrRowID);
			}
	   }
   });
     var value=$.m({
		 ClassName:"web.DHCDocConfig",
		 MethodName:"GetConfigNode",
		 Node:"UseHospSepInstrArcim"
	 },false);
   	 if(+value==1){
		$("#Check_UseHospSepInstrArcim").checkbox('check');
	 }
	$("#cmd_OK").click(SaveExcludePriorSelect);
});
function loadOPInstrArcimDataGrid(InstrRowID)
{
	oPInstrArcimDataGrid.datagrid('unselectAll');
	var Hospital="" 
	if ($("#Check_UseHospSepInstrArcim").is(":checked")) {
			Hospital=$HUI.combogrid('#_HospList').getValue();
	}
	//if(InstrRowID=="")return;
	var queryParams = new Object();
	queryParams.ClassName ='DHCDoc.DHCDocConfig.InstrArcim';
	queryParams.QueryName ='FindOPInstrArcim';
	queryParams.InstrRowId =InstrRowID;
	//queryParams.Arg2 =PUBLIC_CONSTANT.SESSION.GCTLOC_ROWID;	
    queryParams.Hospital =Hospital;		
	//queryParams.ArgCnt =2;
	var opts = oPInstrArcimDataGrid.datagrid("options");
	opts.url = $URL;
	oPInstrArcimDataGrid.datagrid('load', queryParams);
	editRow2 = undefined;	
}
function loadIPInstrArcimDataGrid(InstrRowID)
{
	iPInstrArcimDataGrid.datagrid('unselectAll');
	//var UseHospSepInstrArcim=0
	var Hospital="" 
	if ($("#Check_UseHospSepInstrArcim").is(":checked")) {
		//UseHospSepInstrArcim=1
		Hospital=$HUI.combogrid('#_HospList').getValue();
	}
	//if(InstrRowID=="")return;
	var queryParams = new Object();
	queryParams.ClassName ='DHCDoc.DHCDocConfig.InstrArcim';
	queryParams.QueryName ='FindIPInstrArcim';
	queryParams.InstrRowId =InstrRowID;
	//queryParams.Arg2 =PUBLIC_CONSTANT.SESSION.GCTLOC_ROWID;
    queryParams.Hospital =Hospital;	
	//queryParams.ArgCnt =2;
	var opts = iPInstrArcimDataGrid.datagrid("options");
	opts.url = $URL;
	iPInstrArcimDataGrid.datagrid('load', queryParams);
	editRow3 = undefined;
}
function loadOPInstrArcimSelDataGrid(InstrRowID)
{
	oPInstrArcimSelDataGrid.datagrid('unselectAll');
	//var UseHospSepInstrArcim=0
	var Hospital="" 
	if ($("#Check_UseHospSepInstrArcim").is(":checked")) {
		//UseHospSepInstrArcim=1
		Hospital=$HUI.combogrid('#_HospList').getValue();
	}
	if(InstrRowID=="")return;
	var queryParams = new Object();
	queryParams.ClassName ='DHCDoc.DHCDocConfig.InstrArcim';
	queryParams.QueryName ='FindOPInstrArcimSel';
	queryParams.InstrRowId =InstrRowID;
	//queryParams.Arg2 =PUBLIC_CONSTANT.SESSION.GCTLOC_ROWID;	
	queryParams.HospitalId =Hospital
	//queryParams.ArgCnt =2;
	var opts = oPInstrArcimSelDataGrid.datagrid("options");
	opts.url = $URL;
	oPInstrArcimSelDataGrid.datagrid('load', queryParams);
	editRow2 = undefined;	
}
function loadIPInstrArcimSelDataGrid(InstrRowID)
{
	iPInstrArcimSelDataGrid.datagrid('unselectAll');
	//var UseHospSepInstrArcim=0
	var Hospital="" 
	if ($("#Check_UseHospSepInstrArcim").is(":checked")) {
		//UseHospSepInstrArcim=1
		Hospital=$HUI.combogrid('#_HospList').getValue();
	}
	if(InstrRowID=="")return;
	var queryParams = new Object();
	queryParams.ClassName ='DHCDoc.DHCDocConfig.InstrArcim';
	queryParams.QueryName ='FindIPInstrArcimSel';
	queryParams.InstrRowId =InstrRowID;
	//queryParams.Arg2 =PUBLIC_CONSTANT.SESSION.GCTLOC_ROWID;	
	queryParams.HospitalId =Hospital
	//queryParams.ArgCnt =2;
	var opts = iPInstrArcimSelDataGrid.datagrid("options");
	opts.url = $URL;
	iPInstrArcimSelDataGrid.datagrid('load', queryParams);
	editRow3 = undefined;
}
function searchInstrItem(value,name){
	//console.info(value+","+name)
	loadInstrDataGrid(value);
}
function loadInstrDataGrid(value)
{
	instrDataGrid.datagrid('unselectAll');
	var queryParams = new Object();
	queryParams.ClassName ='DHCDoc.DHCDocConfig.InstrArcim';
	queryParams.QueryName ='FindInstr';
	queryParams.InstrAlias =value;
	//queryParams.ArgCnt =1;
	//console.info(queryParams)
	var opts = instrDataGrid.datagrid("options");
	opts.url = $URL;
	instrDataGrid.datagrid('load', queryParams);
}
function InitHospital()
{
	var hospComp = GenHospComp("Doc_BaseConfig_InstrArcim");
	hospComp.jdata.options.onSelect = function(e,t){
		var select = instrDataGrid.datagrid("getSelected");	
		if (select) {
			var InstrRowID=select.InstrRowID;
		}else{
			var InstrRowID="";
		}
        loadOPInstrArcimDataGrid(InstrRowID);
        loadIPInstrArcimDataGrid(InstrRowID);
        LoadSaveInstrProperty(InstrRowID);
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		//Init();
	}
	/*$("#Combo_Hospital").combobox({      
    	valueField:'HOSPRowId',   
    	textField:'HOSPDesc',
    	url:"./dhcdoc.cure.query.combo.easyui.csp",
    	onBeforeLoad:function(param){
				param.ClassName = 'DHCDoc.DHCDocConfig.InstrArcim';
				param.QueryName = 'GetHos';
				param.ArgCnt =0;
		}  
	});*/
}
function InitDefSpeedRateUnit(){
	$("#Combo_DefSpeedRateUnit").combobox({      
    	valueField:'id',   
    	textField:'desc',
    	url:"./dhcdoc.cure.query.combo.easyui.csp",
    	onBeforeLoad:function(param){
				param.ClassName = 'DHCDoc.DHCDocConfig.InstrArcim';
				param.QueryName = 'GetSpeedFlowRate';
				param.ArgCnt =0;
		}  
	});
}
function ExcludePrior(Type){
	$("#dialog-priorSelect").css("display", ""); 
	dialog1 = $("#dialog-priorSelect" ).dialog({
      autoOpen: false,
      height: 400,
      width: 300,
      modal: true
    });
	dialog1.dialog( "open" );
	$("#List_Prior").html(""); 
	$("#excludePriType").val(Type);
	var objScope=$.cm({ 
		ClassName:"DHCDoc.DHCDocConfig.DocConfig", 
		QueryName:"FindCNMedPrior",
		value:Type,
		HospId:$HUI.combogrid('#_HospList').getValue(),
		rows:99999
	},false);
   var vlist = ""; 
   var selectlist="";
   jQuery.each(objScope.rows, function(i, n) { 
			selectlist=selectlist+"^"+n.selected
			vlist += "<option value=" + n.OECPRRowId + ">" + n.OECPRDesc + "</option>"; 
   });
   $("#List_Prior").append(vlist); 
   for (var j=1;j<=selectlist.split("^").length;j++){
		if(selectlist.split("^")[j]=="true"){
			$("#List_Prior").get(0).options[j-1].selected = true;
		}
	}
}
function SaveExcludePriorSelect()
{
   var Type=$("#excludePriType").val();
   var PriorIDStr="";
   var size = $("#List_Prior"+ " option").size();
   if(size>0){
		$.each($("#List_Prior"+" option:selected"), function(i,own){
          var svalue = $(own).val();
		  if (PriorIDStr=="") PriorIDStr=svalue;
		  else PriorIDStr=PriorIDStr+"^"+svalue;
		})
   }	   
   var str=Type+String.fromCharCode(1)+PriorIDStr;
   var value=$.m({
		 ClassName:"web.DHCDocConfig",
		 MethodName:"SaveConfig",
		 Coninfo:str,
		 HospId:$HUI.combogrid('#_HospList').getValue()
	},false);
	if(value=="0"){
		$.messager.show({title:"提示",msg:"保存成功"});	
        dialog1.dialog( "close" );							
	}
}
//OECSpeedFlowRate
function SaveInstrProperty(){
	var rows = instrDataGrid.datagrid("getSelections");
    if (rows.length > 0){ 
		var ids = [];
        for (var i = 0; i < rows.length; i++) {
            ids.push(rows[i].InstrRowID);
        }
        var InstrRowId=ids.join(',');
        var Hospital="";
		if ($("#Check_UseHospSepInstrArcim").is(":checked")) {
			Hospital=$HUI.combogrid('#_HospList').getValue();
			if(Hospital==""){
				$.messager.alert({title:"提示",msg:"请选择医院"});
                return false;							
			}
		}
		if(Hospital!="") InstrRowId=InstrRowId+"||"+Hospital;
		var DefSpeedRateUnit=$("#Combo_DefSpeedRateUnit").combobox("getValue");
		//多个属性以$C(1)分割
		var PropertyStr="InstrDefSpeedRateUnit"+String.fromCharCode(2)+DefSpeedRateUnit;
		var value=$.m({
			 ClassName:"DHCDoc.DHCDocConfig.InstrArcim",
			 MethodName:"SaveInstrProperty",
			 InstrRowId:InstrRowId,
			 PropertyStr:PropertyStr
		},false);
		$.messager.popover({msg: '保存成功！',type:'success'});
     }else{
        $.messager.alert("提示", "请选择一个要维护的用法"); 
     }
}
function LoadSaveInstrProperty(InstrRowID){
	var Hospital="" 
	if ($("#Check_UseHospSepInstrArcim").is(":checked")) {
		Hospital=$HUI.combogrid('#_HospList').getValue();
	}
	if(InstrRowID=="")return;
	if (Hospital!="") InstrRowID=InstrRowID+"||"+Hospital;
	//多个属性以^分割
	var PropertyStr="InstrDefSpeedRateUnit";
	var InstrProperty=$.m({
		 ClassName:"DHCDoc.DHCDocConfig.InstrArcim",
		 MethodName:"GetInstrProperty",
		 InstrRowId:InstrRowID,
		 PropertyStr:PropertyStr
	},false);
	for (var i=0;i<InstrProperty.split(String.fromCharCode(1)).length;i++) {
		var oneInstrProperty=InstrProperty.split(String.fromCharCode(1))[i];
		var Property=oneInstrProperty.split(String.fromCharCode(2))[0];
		var PropertyValue=oneInstrProperty.split(String.fromCharCode(2))[1];
		var PropertyId="Combo_"+Property;
		setPropertyValue(PropertyId,PropertyValue);
	}
}
function setPropertyValue(PropertyId,PropertyValue)
{
		var _$id=$("#"+PropertyId)
		if (_$id.next().hasClass('combo')){
			_$id.combobox('select',PropertyValue);
		}else if (_$id.hasClass("hisui-switchbox")){
			_$id.switchbox("setValue",PropertyValue);
		}else{
			_$id.val(PropertyValue);
		}
}