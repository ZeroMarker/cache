var NormOrdPriorLimitColumns;
$(function(){
	InitHospList();
	$("#BSave").click(SaveInfo);
	$("#List_NormOrdItemCat").css('height',$(window).height()-155);
})
function InitHospList()
{
	var hospComp = GenHospComp("Doc_BaseConfig_OrdPriorLimit");
	hospComp.jdata.options.onSelect = function(e,t){
		InitList("List_NormOrdItemCat","OnlyNORMItemCat")
		InittabNormOrdPriorLimit();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		InitList("List_NormOrdItemCat","OnlyNORMItemCat")
		InittabNormOrdPriorLimit();
	}
}
function InitList(param1,param2)
{
	$("#"+param1+"").find("option").remove()
	var objScope=$.cm({
		 ClassName:"DHCDoc.DHCDocConfig.ItemPrior",
		 QueryName:"FindCatListPrior",
		 PriorCode:"NORM",
		 value:param2,
		 HospId:$HUI.combogrid('#_HospList').getValue()
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
function InittabNormOrdPriorLimit(){
	var NormOrdPriorLimitToolBar = [{
            text: '增加',
            iconCls: 'icon-add',
            handler: function() { 
				editRow = undefined;
				NormOrdPriorLimitDataGrid.datagrid("rejectChanges");
				NormOrdPriorLimitDataGrid.datagrid('unselectAll');
                if (editRow != undefined) {
                    return;
                }else{
                    NormOrdPriorLimitDataGrid.datagrid("insertRow", {
                        index: 0,
                        row: {}
                    });
                    NormOrdPriorLimitDataGrid.datagrid("beginEdit", 0);
                    editRow = 0;
                }
              
            }
        },{
            text: '删除',
            iconCls: 'icon-cancel',
            handler: function() {
                var rows = NormOrdPriorLimitDataGrid.datagrid("getSelections");
                if (rows.length > 0) {
                    $.messager.confirm("提示", "你确定要删除吗?",
                    function(r) {
                        if (r) {
							var ids = [];
                            for (var i = 0; i < rows.length; i++) {
                                ids.push(rows[i].Index);
                            }
                            var IndexS=ids.join(',');
                            if (IndexS==""){
	                            editRow = undefined;
				                NormOrdPriorLimitDataGrid.datagrid("rejectChanges");
				                NormOrdPriorLimitDataGrid.datagrid("unselectAll");
				                return;
	                        }
	                        var value=$.m({
								 ClassName:"DHCDoc.DHCDocConfig.ItemPrior",
								 MethodName:"DelPriorLimit",
								 Value:"OnlyNORMItemCat",
								 PriorCode:"NORM",
								 IndexS:IndexS,
								 HospId:$HUI.combogrid('#_HospList').getValue()
							},false);
					        if(value=="0"){
						       NormOrdPriorLimitDataGrid.datagrid('load');
       					       NormOrdPriorLimitDataGrid.datagrid('unselectAll');
       					       $.messager.show({title:"提示",msg:"删除成功"});
					        }else{
						       $.messager.alert('提示',"删除失败:"+value);
							   return false;
					        }
					        editRow = undefined;
                        }
                    });
                } else {
                    $.messager.alert("提示", "请选择要删除的行", "error");
                }
            }
        },{
            text: '取消编辑',
            iconCls: 'icon-redo',
            handler: function() {
                //取消当前编辑行把当前编辑行罢undefined回滚改变的数据,取消选择的行
                editRow = undefined;
                NormOrdPriorLimitDataGrid.datagrid("rejectChanges");
                NormOrdPriorLimitDataGrid.datagrid("unselectAll");
            }
        },{
			text: '保存',
			iconCls: 'icon-save',
			handler: function() {
				var editors = NormOrdPriorLimitDataGrid.datagrid('getEditors', editRow);
				var arcrowid = editors[0].target.combobox('getValue');
				if(arcrowid==""){
					$.messager.alert('提示',"请选择医嘱项目");
					return false;
				}
				var SaveInfo=arcrowid;
				var value=$.m({
					 ClassName:"DHCDoc.DHCDocConfig.ItemPrior",
					 MethodName:"SaveOrdPriorLimit",
					 Value:"OnlyNORMItemCat",
					 PriorCode:"NORM",
					 Info:arcrowid,
					 HospId:$HUI.combogrid('#_HospList').getValue()
				},false);
		        if(value=="0"){
			       NormOrdPriorLimitDataGrid.datagrid('load');
			       NormOrdPriorLimitDataGrid.datagrid('unselectAll');
			       $.messager.popover({msg:"保存成功!",type:'success'});
		        }else if(value=="-1"){
					$.messager.alert('提示',"该记录已存在");
					return false;
				}else if(value=="-2"){
					$.messager.alert('提示',"请在下拉框中选择有效的医嘱项!");
					return false;
				}else{
			       $.messager.alert('提示',"保存失败:"+value);
				   return false;
		        }
		        editRow = undefined;
			}
		}];
	NormOrdPriorLimitColumns=[[    
                    { field: 'ArcimDr', title: 'ID', width: 1,hidden:true
					},
					{ field: 'Index', title: 'ID', width: 1,hidden:true
					},
        			{ field: 'ArcimDesc', title: '名称', width: 80,
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
		                             onBeforeLoad:function(param){
						                 var desc=param['q'];
						                 param = $.extend(param,{Alias:param["q"],HospId:$HUI.combogrid('#_HospList').getValue()});
						             }
                        		}
		        		}
					}
    			 ]];
	NormOrdPriorLimitDataGrid=$('#tabNormOrdPriorLimit').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		url:$URL+"?ClassName=DHCDoc.DHCDocConfig.ItemPrior&QueryName=FindOrdPriorLimit&PriorCode=NORM&Value=OnlyNORMItemCat&HospId="+$HUI.combogrid('#_HospList').getValue(),
		loadMsg : '加载中..',  
		pagination : true,  //是否分页
		rownumbers : true,  //
		idField:"Index",
		pageSize:15,
		pageList:[15,50,100,200],
		columns :NormOrdPriorLimitColumns,
		toolbar :NormOrdPriorLimitToolBar,
		onLoadSuccess:function(data){
			editRow = undefined;
			/*editRow = undefined;
			NormOrdPriorLimitDataGrid.datagrid("rejectChanges");
		    NormOrdPriorLimitDataGrid.datagrid("unselectAll");*/
		}
	});
};
function SaveInfo(){
	var NormOrdItemCatStr=""
	var size = $("#List_NormOrdItemCat" + " option").size();
	if(size>0){
		$.each($("#List_NormOrdItemCat"+" option:selected"), function(i,own){
			var svalue = $(own).val();
			if (NormOrdItemCatStr=="") NormOrdItemCatStr=svalue
			else NormOrdItemCatStr=NormOrdItemCatStr+"^"+svalue
		})
	} 
	var value=$.m({
		 ClassName:"DHCDoc.DHCDocConfig.ItemPrior",
		 MethodName:"SavePriorLimitConfig",
		 Value:"OnlyNORMItemCat",
		 PriorCode:"NORM",
		 ItemCatS:NormOrdItemCatStr,
		 HospId:$HUI.combogrid('#_HospList').getValue()
	},false);
	$.messager.popover({msg:"保存成功!",type:'success'});
}