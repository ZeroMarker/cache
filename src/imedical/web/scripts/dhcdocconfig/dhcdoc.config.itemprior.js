var ItemPriorDataGrid;
$(function(){
	InitHospList();
	$('#Confirm').click(SaveOutOrderOtherContral)
})
function InitHospList()
{
	var hospComp = GenHospComp("Doc_BaseConfig_ItemPrior");
	hospComp.jdata.options.onSelect = function(e,t){
		Init();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		Init();
	}
}
function Init(){
	InitListPoison("List_Poison","OutOrderNotPoison");
	InitListItemCat("List_ItemCat","OutOrderNotItemCat")
	InittabItemPrior();
}
function InitListPoison(param1,param2)
{
	$("#"+param1+"").find("option").remove();
	var objScope=$.cm({
		 ClassName:"DHCDoc.DHCDocConfig.ItemPrior",
		 QueryName:"FindPoison",
		 value:param2,
		 HospId:$HUI.combogrid('#_HospList').getValue(),
		 rows:9999
	},false);
   var vlist = ""; 
   var selectlist="";
   jQuery.each(objScope.rows, function(i, n) { 
		    selectlist=selectlist+"^"+n.selected
            vlist += "<option value=" + n.PHCPORowId + ">" + n.PHCPODesc + "</option>"; 
   });
   $("#"+param1+"").append(vlist); 
   for (var j=1;j<=selectlist.split("^").length;j++){
			if(selectlist.split("^")[j]=="true"){
				$("#"+param1+"").get(0).options[j-1].selected = true;
			}
	}
}
function InitListItemCat(param1,param2)
{
	$("#"+param1+"").find("option").remove();
	var objScope=$.cm({
		 ClassName:"DHCDoc.DHCDocConfig.ItemPrior",
		 QueryName:"FindCatList",
		 value:param2,
		 HospId:$HUI.combogrid('#_HospList').getValue(),
		 rows:9999
	},false);
   var vlist = ""; 
   var selectlist="";
   jQuery.each(objScope.rows, function(i, n) { 
		    selectlist=selectlist+"^"+n.selected
            vlist += "<option value=" + n.ARCICRowId + ">" + n.ARCICDesc + "</option>"; 
   });
   $("#"+param1+"").append(vlist); 
   for (var j=1;j<=selectlist.split("^").length;j++){
			if(selectlist.split("^")[j]=="true"){
				$("#"+param1+"").get(0).options[j-1].selected = true;
			}
	}
}
function InittabItemPrior(){
	var ItemPriorToolBar = [{
            text: '增加',
            iconCls: 'icon-add',
            handler: function() { //添加列表的操作按钮添加,修改,删除等
                if (editRow != undefined) {
                    //ItemPriorDataGrid.datagrid("endEdit", editRow);
                    return;
                }else{
	                 //添加时如果没有正在编辑的行，则在datagrid的第一行插入一行
                    ItemPriorDataGrid.datagrid("insertRow", {
                        index: 0,
                        // index start with 0
                        row: {

						}
                    });
                    //将新插入的那一行开户编辑状态
                    ItemPriorDataGrid.datagrid("beginEdit", 0);
                    //cureItemDataGrid.datagrid('addEditor',LocDescEdit);
                    //给当前编辑的行赋值
                    editRow = 0;
                }
              
            }
        },{
            text: '删除',
            iconCls: 'icon-cancel',
            handler: function() {
                //删除时先获取选择行
                var rows = ItemPriorDataGrid.datagrid("getSelections");
                //选择要删除的行
                if (rows.length > 0) {
                    $.messager.confirm("提示", "你确定要删除吗?",
                    function(r) {
                        if (r) {
                            var ids = [];
                            for (var i = 0; i < rows.length; i++) {
                                ids.push(rows[i].rowid);
                            }
                            //将选择到的行存入数组并用,分隔转换成字符串，
                            //本例只是前台操作没有与数据库进行交互所以此处只是弹出要传入后台的id
                            //console.info(ids);
                            var rowid=ids.join(',');
                            if (rowid==""){
	                            editRow = undefined;
				                ItemPriorDataGrid.datagrid("rejectChanges");
				                ItemPriorDataGrid.datagrid("unselectAll");
				                return;
	                        }
                            var value=$.m({
								 ClassName:"DHCDoc.DHCDocConfig.ItemPrior",
								 MethodName:"delete",
								 RowId:rowid
							},false);
							if(value=="0"){
								ItemPriorDataGrid.datagrid('load');
	           					ItemPriorDataGrid.datagrid('unselectAll');
	           					$.messager.show({title:"提示",msg:"删除成功"});
							}else{
								$.messager.alert('提示',"删除失败:"+value);
							}
							editRow = undefined;
                        }
                    });
                } else {
                    $.messager.alert("提示", "请选择要删除的行", "error");
                }
            }
        },{
            text: '保存',
            iconCls: 'icon-save',
            handler: function() {
                //保存时结束当前编辑的行，自动触发onAfterEdit事件如果要与后台交互可将数据通过Ajax提交后台
              var rows = ItemPriorDataGrid.datagrid("getSelections");
                if (editRow != undefined)
                {
                	var editors = ItemPriorDataGrid.datagrid('getEditors', editRow);      
					var BillTypeRowid =  editors[0].target.combobox('getValue');
					if (!BillTypeRowid){
						$.messager.alert('提示',"请选择费别!")
						return false;
					}
					var ItemCatRowid =  editors[1].target.combobox('getValue');
					if (!ItemCatRowid){
						$.messager.alert('提示',"请选择医嘱子类!")
						return false;
					}
					var DurationRowid =  editors[2].target.combobox('getValue');
					if (!DurationRowid){
						$.messager.alert('提示',"请选择疗程不能为空!")
						return false;
					}
					var Drugspecies=editors[3].target.val();
					if (Drugspecies!=""){
						if (isNaN(Number(Drugspecies))==true){
							$.messager.alert('提示',"药品种类请填写数字!")
							return false;
						}
					}
					var Para=ItemCatRowid+"^"+BillTypeRowid+"^"+DurationRowid+"^"+Drugspecies;
					var value=$.m({
						 ClassName:"DHCDoc.DHCDocConfig.ItemPrior",
						 MethodName:"insert",
						 Para:Para,
						 HospId:$HUI.combogrid('#_HospList').getValue()
					},false);
					if(value==0){
						ItemPriorDataGrid.datagrid("endEdit", editRow);
            			editRow = undefined;
						ItemPriorDataGrid.datagrid('load');
       					ItemPriorDataGrid.datagrid('unselectAll');
       					//$.messager.alert({title:"提示",msg:"保存成功"});           					
					}else{
						$.messager.alert('提示',"保存失败:"+value);
						return false;
					}
					editRow = undefined;
            	}
            }
        },{
            text: '取消编辑',
            iconCls: 'icon-redo',
            handler: function() {
                //取消当前编辑行把当前编辑行罢undefined回滚改变的数据,取消选择的行
                editRow = undefined;
                ItemPriorDataGrid.datagrid("rejectChanges");
                ItemPriorDataGrid.datagrid("unselectAll");
            }
        }];
    var ItemPriorColumns=[[    
        			{ field: 'rowid', title: '', width: 100,hidden:true},
					{
                      field : 'BillTypeRowid',title : '费别',width : 100,
					  editor :{  
							type:'combobox',  
							options:{
								url:$URL+"?ClassName=DHCDoc.DHCDocConfig.CNMedCode&QueryName=FindBillTypeConfig&value=&HospId="+$HUI.combogrid('#_HospList').getValue(),
								valueField:'BillTypeRowid',
								textField:'BillTypeDesc',
								required:false,
								loadFilter:function(data){
								    return data['rows'];
								}
							  }
     					  },
						formatter:function(BillTypeRowid,record){
							  return record.BillType;
						}
                    },
                     { field : 'BillType',title : '',width : 120,hidden:true   
                     },
					 { field: 'ItemCatRowid', title: '医嘱子类', width: 250,
					   editor :{  
							type:'combobox',  
							options:{
								url:$URL+"?ClassName=DHCDoc.DHCDocConfig.ItemPrior&QueryName=FindCatList&value=&HospId="+$HUI.combogrid('#_HospList').getValue(),
								valueField:'ARCICRowId',
								textField:'ARCICDesc',
								required:false,
								loadFilter:function(data){
								    return data['rows'];
								}
							  }
     					  },
						formatter:function(id,record){
							  return record.ItemCat;
						}
					 },
					 { field: 'ItemCat', title: 'ItemCat', width: 100, align: 'center', sortable: true, hidden: true},
					 { field: 'DurationRowid', title: '限定疗程', width: 100, align: 'center', sortable: true,
					    editor :{  
							type:'combobox',  
							options:{
								url:$URL+"?ClassName=DHCDoc.DHCDocConfig.SubCatContral&QueryName=FindDurList&value=&Type=XY",
								valueField:'DurRowId',
								textField:'DurCode',
								required:false,
								loadFilter:function(data){
								    return data['rows'];
								}
							  }
     					  },
						formatter:function(id,record){
							  return record.Duration;
						}
					 },
					 { field: 'Duration', title: '', width: 100,hidden: true},
					 { field: 'Drugspecies', title: '限定药品种类', width: 100,
					   editor : {type : 'text',options : {}}
					 }
    			 ]];
	ItemPriorDataGrid=$("#tabItemPrior").datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		url:$URL+"?ClassName=DHCDoc.DHCDocConfig.ItemPrior&QueryName=Find&Alias=&HospId="+$HUI.combogrid('#_HospList').getValue(),
		loadMsg : '加载中..',  
		pagination : true,  //
		rownumbers : true,  //
		idField:"InstrArcimId",
		pageSize:15,
		pageList : [15,50,100,200],
		columns :ItemPriorColumns,
    	toolbar :ItemPriorToolBar,
    	onLoadSuccess:function(data){
	    	editRow = undefined;
	    }
	});
}
function SaveOutOrderOtherContral()
{
   var PoisonStr=""
   var size = $("#List_Poison" + " option").size();
   if(size>0){
	   $.each($("#List_Poison"+" option:selected"), function(i,own){
              var svalue = $(own).val();
			  if (PoisonStr=="") PoisonStr=svalue
			  else PoisonStr=PoisonStr+"^"+svalue
			})
   } 
   var objScope=$.m({
		 ClassName:"DHCDoc.DHCDocConfig.ItemPrior",
		 MethodName:"SaveConfig",
		 node:"OutOrderNotPoison",
		 value:PoisonStr,
		 HospId:$HUI.combogrid('#_HospList').getValue()
	},false);
   var CatStr=""
   var size = $("#List_ItemCat" + " option").size();
   if(size>0){
	   $.each($("#List_ItemCat"+" option:selected"), function(i,own){
              var svalue = $(own).val();
			  if (CatStr=="") CatStr=svalue
			  else CatStr=CatStr+"^"+svalue
		})
   } 
   var objScope=$.m({
		 ClassName:"DHCDoc.DHCDocConfig.ItemPrior",
		 MethodName:"SaveConfig",
		 node:"OutOrderNotItemCat",
		 value:CatStr,
		 HospId:$HUI.combogrid('#_HospList').getValue()
	},false);
	$.messager.show({title:"提示",msg:"保存成功"});
}