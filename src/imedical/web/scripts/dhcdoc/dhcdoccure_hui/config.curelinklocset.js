var PageLogicObj={
	editRow1:undefined,
	selectRowFlag:false,
	DocCureUseBase:"0",
	CureLocDataGrid:"",
	CureLinkLocDataGrid:""
}
var arrayObj1 = new Array(
	  new Array("Chk_CureLocNeedTriage","CureLocNeedTriage"),
	  new Array("Chk_CureLocNeedReport","CureLocNeedReport"),
	  //new Array("Chk_CureLocAppointAllowExec","CureLocAppAllowExec"),
	  //new Array("Chk_CureLocAppDoseQty","CureLocAppDoseQty"),
	  new Array("Chk_CureLocAppHiddenOtherUser","CureLocAppHiddenOtherUser"),
	  new Array("Chk_CureLocWorkQrySelf","CureLocWorkQrySelf")
);
var arrayObj2 = new Array(
	  new Array("Chk_CureLocReconfirm","CureLocReconfirm")
);
var arrayObj3 = new Array(
	  new Array("Combo_RelateAssTemp","CureLocRelateAssTemp")
);
$(document).ready(function(){ 
	 InitHospList();
	 InitEvent();
});
function InitHospList()
{
	var hospStr=session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']
	var hospComp = GenHospComp("Doc_Cure_LinkLoc",hospStr);
	hospComp.jdata.options.onSelect = function(e,t){
		$("#SLocDesc").searchbox("setValue","");
		PageHandle();
		CureLocDataGridLoad();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		PageLogicObj.CureLocDataGrid=Init();
		PageHandle();
		InitRelateTemp();
		CureLocDataGridLoad();
	}
}
function Init()
{
	var CureLocDataGrid=$('#tabCureLoc').datagrid({  
		fit : true,
		border : false,
		striped : true,
		remoteSort:false,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		loadMsg : '加载中..',  
		pagination : false,
		rownumbers : true,
		idField:"LocRowID",
		columns :[[    
			{ field: 'LocDesc', title: '治疗科室名称', width: 200
			},
			{ field: 'LocRowID', title: '科室ID', width: 200,hidden:true
			}
		]],
		onDblClickRow:function(rowIndex, rowData){ 
			//LinkLocClickHandle();
       	},onClickRow:function(rowIndex, rowData){
	       	LoadCureLocConfig(rowData);
	    }
	});
	return CureLocDataGrid;
};

function InitEvent(){
	$("#SaveCureLocExp").click(function(){
		SaveCureLocExp();	
	})
	$("#RefLinkLoc").click(function(){
		LinkLocClickHandle();	
	})
}

function PageHandle(){
	for(var i=0;i<arrayObj1.length;i++){
		var param1=arrayObj1[i][0];
		var param2=arrayObj1[i][1];
		var obj=$HUI.switchbox("#"+param1+"");
		obj.setValue(false);
	}	
	for(var i=0;i<arrayObj2.length;i++){
		var param1=arrayObj2[i][0];
		var param2=arrayObj2[i][1];
		var obj=$HUI.switchbox("#"+param1+"");
		obj.setValue(false);
	}	
	var UserHospID=Util_GetSelHospID();
	$.cm({
		ClassName:"DHCDoc.DHCDocCure.VersionControl",
		MethodName:"UseBaseControl",
		HospitalId:UserHospID,
		dataType:"text"
	},function(DocCureUseBase){
		PageLogicObj.DocCureUseBase=DocCureUseBase;
		for(var i=0;i<arrayObj1.length;i++){
			var param1=arrayObj1[i][0];
			var param2=arrayObj1[i][1];
			var obj=$HUI.switchbox("#"+param1+"");
			if(DocCureUseBase==1){
				obj.setActive(false)
			}else{
				obj.setActive(true)
			}
		}	
	});
}

function InitRelateTemp(){
	$HUI.combobox("#Combo_RelateAssTemp",{
		multiple:true,
		rowStyle:'checkbox', //显示成勾选行形式
		selectOnNavigation:false,
		url:$URL+"?ClassName=web.DHCDocAPPBL&QueryName=FindBLType&MapType=CA&ResultSetType=array",
		valueField:'RowID',
		textField:'BLTypeDesc'
	});	
}

function SaveCureLocExp(){
	var selected = PageLogicObj.CureLocDataGrid.datagrid('getSelected');
	if (selected){
		var ConfigObj={};
		for(var i=0;i<arrayObj1.length;i++){
			var param1=arrayObj1[i][0];
			var param2=arrayObj1[i][1];
			var val=$HUI.switchbox("#"+param1).getValue();
			val=val?"Y":"N";
			ConfigObj[param2]=val;
		}	
		for(var i=0;i<arrayObj2.length;i++){
			var param1=arrayObj2[i][0];
			var param2=arrayObj2[i][1];
			var val=$HUI.switchbox("#"+param1).getValue();
			val=val?"Y":"N";
			ConfigObj[param2]=val;
		}
		for(var i=0;i<arrayObj3.length;i++){
			var param1=arrayObj3[i][0];
			var param2=arrayObj3[i][1];
			var val=$HUI.combobox("#"+param1).getValues();
			if(!val){
				val="";
			}else{
				val=val.join(",");		
			}
	
			ConfigObj[param2]=val;
		}
		var Rowid=selected.LocRowID;
		var ConfigInfo=JSON.stringify(ConfigObj);
		$.cm({
			ClassName:"DHCDoc.DHCDocCure.Config",
			MethodName:"SaveCureLocConfig",
			CureLocID:Rowid,
			ConfigInfo:ConfigInfo,
			dataType:"text"
		},function(ret){
			if(ret=="0"){
				$.messager.popover({msg: '保存成功!',type:'success',timeout: 3000});
			}else{
				$.messager.alert('提示',"保存失败,错误代码:"+ret,"warning");	
			}
		})
	}else{
		$.messager.alert('提示',"请选择需配置的治疗科室记录!","warning");
	}
}

function LinkLocClickHandle(){
	var row = PageLogicObj.CureLocDataGrid.datagrid('getSelected');
	if (row){
		var LocRowID=row.LocRowID
	    $("#dialog-CureLinkLoc").css("display", ""); 
		var dialog1 = $HUI.dialog("#dialog-CureLinkLoc",{ //$("#dialog-CureLinkLoc").dialog({
			autoOpen: false,
			height: 500,
			width: 400,
			modal: true
		});
		dialog1.dialog( "open" );
		PageLogicObj.CureLinkLocDataGrid=InitCureLinkLoc(LocRowID);	
	}else{
		$.messager.alert('提示',"请选择需配置的治疗科室记录!","warning");
		return false;
	}
}
function CureLocDataGridLoad()
{ 
	var HospDr=Util_GetSelHospID();
	var LocDesc=$("#SLocDesc").searchbox("getValue");
	$.cm({
		ClassName:"DHCDoc.DHCDocCure.Config",
		QueryName:"FindLoc",
		Loc:LocDesc,
		CureFlag:"1",
		Hospital:HospDr,
		Pagerows:PageLogicObj.CureLocDataGrid.datagrid("options").pageSize,
		rows:99999
	},function(GridData){
		PageLogicObj.CureLocDataGrid.datagrid("unselectAll").datagrid({loadFilter:pagerFilter}).datagrid('loadData',GridData); 
		PageLogicObj.selectRowFlag=false;
	})
	
};
function InitCureLinkLoc(Rowid)
{
	var CureLinkToolBar = [{
            text: '增加',
            iconCls: 'icon-add',
            handler: function() { //添加列表的操作按钮添加,修改,删除等
			    //PageLogicObj.editRow1 = undefined;
                PageLogicObj.CureLinkLocDataGrid.datagrid("unselectAll");
                if (PageLogicObj.editRow1 != undefined) {
	                //$.messager.alert("提示", "有正在编辑的行，请先点击保存", "error");
                    //CureLinkLocDataGrid.datagrid("endEdit", PageLogicObj.editRow1);
                    return;
                }else{
                    PageLogicObj.CureLinkLocDataGrid.datagrid("insertRow", {
                        index: 0,
                        row: {
							RowID:"",
							LinkLocRowID:"",
							LocDesc:"",						
						}
                    });
                    PageLogicObj.CureLinkLocDataGrid.datagrid("beginEdit", 0);
                    PageLogicObj.editRow1 = 0;
                }
              
            }
        },{
            text: '保存',
            iconCls: 'icon-save',
            handler: function() {
	            if(PageLogicObj.editRow1==undefined){
					return false;
			  	}
                var rows = PageLogicObj.CureLinkLocDataGrid.datagrid("getRows");
				if (rows.length > 0){
				   for (var i = 0; i < rows.length; i++) {
					   if(PageLogicObj.editRow1==i){
						   var rows=PageLogicObj.CureLinkLocDataGrid.datagrid("selectRow",PageLogicObj.editRow1).datagrid("getSelected");  
						   var editors = PageLogicObj.CureLinkLocDataGrid.datagrid('getEditors', PageLogicObj.editRow1); 
						   var LinkLocRowID=editors[0].target.combobox('getValue');
						   if ((!LinkLocRowID)||(rows.LinkLocRowID=="")){
								$.messager.alert('提示',"请选择关联科室");
								return false;
				            }
							$.m({
								ClassName:"DHCDoc.DHCDocCure.Config",
								MethodName:"insertLinkLoc",
								'MainLocID':Rowid,
								'LinkLocID':LinkLocRowID
							},function testget(value){
								if(value=="0"){
									PageLogicObj.CureLinkLocDataGrid.datagrid("endEdit", PageLogicObj.editRow1);
									PageLogicObj.editRow1 = undefined;
									CureLinkLocDataGridLoad(Rowid);
									$.messager.popover({type:"success",msg:"保存成功",timeout:3000});
								}else if(value=="-1"){
									$.messager.alert('提示',"保存失败,该记录已存在");
									return false;
								}else if(value=="-2"){
									$.messager.alert('提示',"保存失败,请正确选择关联科室");
									return false;
								}else if(value=="-101"){
									$.messager.alert('提示',"保存失败,本科室不能关联自身");
									return false;
								}else{
									$.messager.alert('提示',"保存失败:"+value);
									return false;
								}
								PageLogicObj.editRow1 = undefined;
								
							});
					   }
				   }
				}

            }
        }, {
            text: '取消编辑',
            iconCls: 'icon-redo',
            handler: function() {
                PageLogicObj.editRow1 = undefined;
                PageLogicObj.CureLinkLocDataGrid.datagrid("rejectChanges").datagrid("unselectAll");
            }
        },
        {
            text: '删除',
            iconCls: 'icon-remove',
            handler: function() {
                //删除时先获取选择行
                var rows = PageLogicObj.CureLinkLocDataGrid.datagrid("getSelections");
                //选择要删除的行
                if (rows.length > 0) {
                    $.messager.confirm("提示", "你确定要删除吗?",
                    function(r) {
                        if (r) {
                            var ids = [];
                            for (var i = 0; i < rows.length; i++) {
                                ids.push(rows[i].RowID);
                            }
                            var RowID=ids.join(',');
                            if (RowID==""){
	                            PageLogicObj.editRow1 = undefined;
				                PageLogicObj.CureLinkLocDataGrid.datagrid("rejectChanges");
				                PageLogicObj.CureLinkLocDataGrid.datagrid("unselectAll");
				                return;
	                        }
                            $.m({
	                            ClassName:"DHCDoc.DHCDocCure.Config",
	                            MethodName:"deleteLink",
	                            'RowID':RowID
                            },function testget(value){
								if(value=="0"){
									CureLinkLocDataGridLoad(Rowid);
		           					$.messager.popover({type:"success",msg:"删除成功",timeout:3000});
								}else{
									$.messager.alert('提示',"删除失败:"+value,"warning");
								}
								PageLogicObj.editRow1 = undefined;
							});
                        }
                    });
                } else {
                    $.messager.alert("提示", "请选择要删除的行", "error");
                }
	         
            }
        }];
	var CureLinkColumns=[[    
		{ field: 'RowID', title: '', width: 1, align: 'center', sortable: true,hidden:true
		},
		{ field: 'LinkLocRowID', title: '', width: 1, align: 'center', sortable: true,hidden:true
		},
		{ field: 'LocDesc', title: '关联科室名称', width: 300, align: 'center', sortable: true,
		  editor:{
				type:'combogrid',
				options:{
					required: true,
					panelWidth:300,
					panelHeight:350,
					idField:'LocRowID',
					textField:'LocDesc',
					value:'',
					mode:'remote',
					pagination : true,
					rownumbers:true,
					collapsible:false,
					fit: true,
					pageSize: 10,
					pageList: [10],
					//url:PUBLIC_CONSTANT.URL.QUERY_GRID_URL,
					columns:[[
                        {field:'LocDesc',title:'名称',width:250,sortable:true},
	                    {field:'LocRowID',title:'LocRowID',width:120,sortable:true,hidden:true},
	                    {field:'selected',title:'LocRowID',width:120,sortable:true,hidden:true}
                     ]],
                     onShowPanel:function(){
                        var trObj = $HUI.combogrid(this);
						var object1 = trObj.grid();
                     	LoadItemData("",object1)
                     },
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
						      var rows=PageLogicObj.CureLinkLocDataGrid.datagrid("selectRow",PageLogicObj.editRow1).datagrid("getSelected");
                              rows.LinkLocRowID=selected.LocRowID
						    }
						    //
			                //选中后让下拉表格消失
			                $(this).combogrid('hidePanel');
							$(this).focus();
			            },
						 query:function(q){
							var object1=new Object();
							object1=$(this)
							var trObj = $HUI.combogrid(this);
							var object1 = trObj.grid();

							if (this.AutoSearchTimeOut) {
								window.clearTimeout(this.AutoSearchTimeOut)
								this.AutoSearchTimeOut=window.setTimeout(function(){ LoadItemData(q,object1);},400); 
							}else{
								this.AutoSearchTimeOut=window.setTimeout(function(){ LoadItemData(q,object1);},400); 
							}
							$(this).combogrid("setValue",q);
						}
        			},
        			onSelect:function(rowIndex, rowData){
				      var rows=PageLogicObj.CureLinkLocDataGrid.datagrid("selectRow",PageLogicObj.editRow1).datagrid("getSelected");
                      rows.LinkLocRowID=rowData.LocRowID
            		},
            		onChange:function(Value,oldValue){
                		if (!Value) {
                    		var rows=PageLogicObj.CureLinkLocDataGrid.datagrid("selectRow",PageLogicObj.editRow1).datagrid("getSelected");
                      		rows.LinkLocRowID="";
                    	}
                	}
        		}
			 }
		  
		}
	 ]];
	var CureLinkLocDataGrid=$('#tabCureLinkLoc').datagrid({  
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		url:$URL+"?ClassName=DHCDoc.DHCDocCure.Config&QueryName=FindCureLinkLoc",
		loadMsg : '加载中..',  
		pagination : true,  
		rownumbers : true, 
		idField:"RowID",
		pageSize:10,
		pageList : [10,20,50],
		columns :CureLinkColumns,
		toolbar :CureLinkToolBar,
		onBeforeLoad:function(param){
			PageLogicObj.editRow1 = undefined;
			$("#tabCureLinkLoc").datagrid('unselectAll');
			param = $.extend(param,{RowIDLocRowID:Rowid});
		}
	});
	return CureLinkLocDataGrid;
}

function CureLinkLocDataGridLoad(Rowid)
{
	PageLogicObj.CureLinkLocDataGrid.datagrid('reload').datagrid('unselectAll');;
};

function LoadItemData(q,obj1){
	var val = q //$('#Combo_CTLoc').combogrid('getValue'); 
	var HospDr=Util_GetSelHospID();
	$.cm({
		ClassName:"DHCDoc.DHCDocCure.Config",
		QueryName:"FindLoc",
		Loc:val,
		CureFlag:"1",
		Hospital:HospDr,
		Pagerows:obj1.datagrid("options").pageSize,
		rows:99999
	},function(GridData){
		obj1.datagrid({loadFilter:pagerFilter}).datagrid('loadData',GridData); 
	})
	
}

function LoadCureLocConfig(rowData){
	for(var i=0;i<arrayObj1.length;i++){
		SetValue(arrayObj1[i])
	}	
	for(var i=0;i<arrayObj2.length;i++){
		SetValue(arrayObj2[i])
	}
	for(var i=0;i<arrayObj3.length;i++){
		SetValue(arrayObj3[i])
	}
	function SetValue(obj){
		var param1=obj[0];
		var param2=obj[1];
		$.cm({
			ClassName:"DHCDoc.DHCDocCure.Config",
			MethodName:"GetCureLocConfig",
			CureLocID:rowData.LocRowID,
			NodeName:param2,
			HospId:Util_GetSelHospID(),			
			dataType:"text"
		},function(ret){
			var className=$("#"+param1).attr("class");
			if(className.indexOf("hisui-combobox")>=0){
				if(ret==0)ret="";
				var optobj=$("#"+param1).combobox("options");
				var mulval=optobj.multiple;	
				if(mulval){
					var TempArr=[];
					if(ret!=""){
						TempArr=ret.split(",");
					}
					$('#'+param1).combobox('setValues',TempArr);
				}else{
					$('#'+param1).combobox('setValue',ret);	
				}
			}else{
				var sobj=$HUI.switchbox("#"+param1+"");
				//var CAQObj=$HUI.switchbox('#Chk_CureLocAppDoseQty');
				
				if(ret=="1"){
					sobj.setValue(true);
					/*if(param1=="Chk_CureLocAppointAllowExec"){
						CAQObj.setValue(true);
						CAQObj.setActive(false);
					}*/
				}else{
					sobj.setValue(false);
					/*if(param1=="Chk_CureLocAppointAllowExec"){
						if(PageLogicObj.DocCureUseBase=="0"){
							CAQObj.setActive(true);
						}
					}*/
				}
			}
		})	
	}
}

function CureAppointAllowExecChange(e,obj){
	var myobj=$HUI.switchbox('#Chk_CureLocAppDoseQty')
	if (obj.value) {
		myobj.setValue(true);
		myobj.setActive(false);
	}else{
		myobj.setActive(true);
	}	
}