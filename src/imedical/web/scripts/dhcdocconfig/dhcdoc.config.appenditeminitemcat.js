var PageLogicObj={
	m_AppendItemInItemCatDataGrid:""
}
var editRow=undefined;
$(function(){
	InitHospList();
});
function InitHospList()
{
	var hospComp = GenHospComp("DHC_ItmSubCatAdd");
	hospComp.jdata.options.onSelect = function(e,t){
		PageHandle();
		PageLogicObj.m_AppendItemInItemCatDataGrid.datagrid('loadData',{"total":0,"rows":[]});
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		Init();
		PageHandle();
		InitCache();
	}
}
function Init(){
	PageLogicObj.m_AppendItemInItemCatDataGrid=InitAppendItemInItemCatDataGrid();
}
function InitCache(){
	var hasCache = $.DHCDoc.ConfigHasCache();
	if (hasCache!=1) {
		$.DHCDoc.CacheConfigPage();
		$.DHCDoc.storageConfigPageCache();
	}
}
function PageHandle(){
	$.q({
	    ClassName : "DHCDoc.DHCDocConfig.SubCatContral",
	    QueryName : "FindCatList",
	    value:"AppendItemCat",
	    HospId:$HUI.combogrid('#_HospList').getValue(),
	    rows:99999
	},function(GridData){
		var cbox = $HUI.combobox("#List_ItemCat", {
				valueField: 'ARCICRowId',
				textField: 'ARCICDesc', 
				editable:true,
				data: GridData["rows"],
				filter: function(q, row){
					return (row["ARCICDesc"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
				},
				onSelect:function(row){
					//AppendItemInItemCatDataGridLoad();
				},
				onUnselect:function(row){
					//AppendItemInItemCatDataGridLoad();
				},
				onHidePanel:function(){
					AppendItemInItemCatDataGridLoad();
				}
		 });
	});
}
function InitAppendItemInItemCatDataGrid(){
	var toolBar = [{
            text: '����',
            iconCls: 'icon-add',
            handler: function() { 
            var ItemCatDr=getValue('List_ItemCat');
			if (ItemCatDr==""){
				$.messager.alert('��ʾ',"����ѡ��ҽ������!");
				return false;
			}
			    editRow = undefined;
				RowBillType="";
                PageLogicObj.m_AppendItemInItemCatDataGrid.datagrid("rejectChanges");
                PageLogicObj.m_AppendItemInItemCatDataGrid.datagrid("unselectAll");
                if (editRow != undefined) {
                    return;
                }else{
                    PageLogicObj.m_AppendItemInItemCatDataGrid.datagrid("insertRow", {
                        index: 0,
                        row: {}
                    });
                     editRow = 0;
                    PageLogicObj.m_AppendItemInItemCatDataGrid.datagrid("beginEdit", 0);
                }
              
            }
        },{
            text: 'ɾ��',
            iconCls: 'icon-cancel',
            handler: function() {
                var rows = PageLogicObj.m_AppendItemInItemCatDataGrid.datagrid("getSelections");
                if (rows.length > 0) {
                    $.messager.confirm("��ʾ", "��ȷ��Ҫɾ����?",
                    function(r) {
                        if (r) {
							var ids = [];
                            for (var i = 0; i < rows.length; i++) {
                                ids.push(rows[i].DHCICARowid);
                            }
                            var DHCICARowid=ids.join(',')
                            if (DHCICARowid==""){
	                            editRow = undefined;
								RowBillType="";
				                PageLogicObj.m_AppendItemInItemCatDataGrid.datagrid("rejectChanges");
				                PageLogicObj.m_AppendItemInItemCatDataGrid.datagrid("unselectAll");
				                return false;
	                        }
	                        $.cm({
								ClassName:"DHCDoc.DHCDocConfig.AppendItemInItemCat",
								MethodName:"delete",
								DHCICARowid:DHCICARowid
							},function(rtn){
								if (rtn=="0"){
									$.messager.popover({"msg":"ɾ���ɹ�!",type:"success"});
									AppendItemInItemCatDataGridLoad();
								}else{
									$.messager.alert("��ʾ","ɾ��ʧ��!"+rtn);
									return false;
								}
							});
                        }
                    });
                } else {
                    $.messager.alert("��ʾ", "��ѡ��Ҫɾ������!");
                }
            }
        },{
            text: 'ȡ���༭',
            iconCls: 'icon-undo',
            handler: function() {
                editRow = undefined;
                PageLogicObj.m_AppendItemInItemCatDataGrid.datagrid("rejectChanges");
                PageLogicObj.m_AppendItemInItemCatDataGrid.datagrid("unselectAll");
            }
        },{
			text: '����',
			iconCls: 'icon-save',
			handler: function() {
			    SaveClickHandle();
			}
		}
		];
	Columns=[[
			{ field: 'DHCIAARCICDesc', title: '��������', width: 100
			},
            { field: 'ARCIMRowid', title: '����', width: 100,hidden:true
			}, 
			{ field: 'ARCIMDesc', title:'ҽ������', width: 230,
			   editor:{
                         type:'combogrid',
                         options:{
	                         enterNullValueClear:false,
                             required: true,
                             panelWidth:450,
							 panelHeight:290,
							 delay:500,
                             idField:'ArcimRowID',
                             textField:'ArcimDesc',
                            value:'',//ȱʡֵ 
                            mode:'remote',
							pagination : true,//�Ƿ��ҳ   
							rownumbers:true,//���   
							collapsible:false,//�Ƿ���۵���   
							fit: true,//�Զ���С   
							pageSize: 10,//ÿҳ��ʾ�ļ�¼������Ĭ��Ϊ10   
							pageList: [10],//��������ÿҳ��¼�������б�  
                            url:$URL+"?ClassName=DHCDoc.DHCDocConfig.Items&QueryName=FindItem",
                            columns:[[
                                {field:'ArcimDesc',title:'����',width:400,sortable:true},
			                    {field:'ArcimRowID',title:'ID',width:120,sortable:true},
			                    {field:'selected',title:'ID',width:120,sortable:true,hidden:true}
                             ]],
                             onSelect: function (rowIndex, rowData){
								 var rows=PageLogicObj.m_AppendItemInItemCatDataGrid.datagrid("selectRow",editRow).datagrid("getSelected");
								 rows.ARCIMRowid=rowData.ArcimRowID;
								 var editDoseObj=PageLogicObj.m_AppendItemInItemCatDataGrid.datagrid('getEditor', {index:editRow,field:'Dose'});
								$(editDoseObj.target).val("");
								 var EditDoseUomObj=PageLogicObj.m_AppendItemInItemCatDataGrid.datagrid('getEditor', {index:editRow,field:'DoseUom'});
								 EditDoseUomObj.target.combobox('reload').combobox('select',"");
								 var EditSPECDescObj=PageLogicObj.m_AppendItemInItemCatDataGrid.datagrid('getEditor', {index:editRow,field:'SPECDesc'});
								 EditSPECDescObj.target.combobox('reload').combobox('select',"");
							 },
                             onClickRow : function(rowIndex, rowData) {
                    			var rows=PageLogicObj.m_AppendItemInItemCatDataGrid.datagrid("selectRow",editRow).datagrid("getSelected");
                                if(rows) rows.ARCIMRowid=rowData.ArcimRowID;
                                var editDoseObj=PageLogicObj.m_AppendItemInItemCatDataGrid.datagrid('getEditor', {index:editRow,field:'Dose'});
								$(editDoseObj.target).val("");
							
                                var EditDoseUomObj=PageLogicObj.m_AppendItemInItemCatDataGrid.datagrid('getEditor', {index:editRow,field:'DoseUom'});
								 EditDoseUomObj.target.combobox('reload').combobox('select',"");
								 var EditSPECDescObj=PageLogicObj.m_AppendItemInItemCatDataGrid.datagrid('getEditor', {index:editRow,field:'SPECDesc'});
								 EditSPECDescObj.target.combobox('reload').combobox('select',"");
			                 },
							onLoadSuccess:function(data){
								$(this).next('span').find('input').focus();
							},
							onBeforeLoad:function(param){
								if (param['q']) {
									var desc=param['q'];
								}else{
									//return false;
								}
								param = $.extend(param,{Alias:desc,HospId:$HUI.combogrid('#_HospList').getValue()});
							}
                		}
        			  }
			  
			},
			{ field: 'Qty', title: '��С����', width: 70,
			  editor : {type : 'text',options : {required:true}}
			},{ field: 'Loc', title: '����', width: 150, resizable: true,
			  editor : {
				   type : 'combobox',options : {
					valueField:'LocRowID',   
					textField:'LocDesc',
					url:$URL+"?ClassName=DHCDoc.DHCDocConfig.LocExt&QueryName=GetLocExtConfigNew&LocId=&rows=99999",
					onSelect:function(record) {
						var rows=PageLogicObj.m_AppendItemInItemCatDataGrid.datagrid("selectRow",editRow).datagrid("getSelected");
	                    if(rows)rows.LocId=record.LocRowID
					},
					onBeforeLoad:function(param){
			            if (param['q']) {
							var desc=param['q'];
						}else{
							var desc="";
						}
						param = $.extend(param,{HospId:$HUI.combogrid('#_HospList').getValue()});
					},
					loadFilter:function(data){
					    return data['rows'];
					},
					onChange:function(NewValue,OldValue) {
						if (NewValue==""){
							var rows=PageLogicObj.m_AppendItemInItemCatDataGrid.datagrid("selectRow",editRow).datagrid("getSelected");
	                    	if(rows)rows.LocId="";
						}
					},filter: function(q, row){
						var opts = $(this).combobox('options');
						var str=q.toUpperCase()
						var LocDesc=row[opts.textField]
						var LocAlias=row["LocAlias"]
						if(LocDesc.toUpperCase().indexOf(str)>=0) return true
						if(LocAlias.toUpperCase().indexOf(str)>=0) return true
						return false;
					}		
				  }
			  }
			},{ field: 'LocId', title: '', width: 1,hidden:true
			},{ field: 'RecLoc', title: '���տ���', width: 150, resizable: true,
			  editor : {type : 'combobox',options : {
				mode:'remote',
				valueField:'CTLOCRowID',  //LocRowID
				textField:'CTLOCDesc', //LocDesc
				url:"./dhcdoc.cure.query.combo.easyui.csp",
				//url:$URL+"?ClassName=DHCDoc.DHCDocConfig.LocExt&QueryName=GetLocExtConfigNew&LocId=&rows=99999",
				onBeforeLoad:function(param){
					var q=param.q;
					if (!q) q="";
					param.ClassName = 'web.DHCBL.CT.CTLoc'; //DHCDoc.DHCDocConfig.LocExt
					param.QueryName = 'GetDataForCmb1'; //GetLocExtConfigNew
					param.Arg1 ="";
					param.Arg2="";
					param.Arg3=q;
					param.Arg4="";
					param.Arg5="";
					param.Arg6="";
					param.Arg7=""; //$HUI.combogrid('#_HospList').getValue()
					param.ArgCnt =7;
				},
				onChange:function(NewValue,OldValue) {
					if (NewValue==""){
						var rows=PageLogicObj.m_AppendItemInItemCatDataGrid.datagrid("selectRow",editRow).datagrid("getSelected");
                    	if(rows)rows.RecLocId="";
					}
				},onSelect:function(record) {
					var rows=PageLogicObj.m_AppendItemInItemCatDataGrid.datagrid("selectRow",editRow).datagrid("getSelected");
                    if(rows)rows.RecLocId=record.CTLOCRowID; //LocRowID
					
				}/*,loadFilter:function(data){
					    return data['rows'];
				},filter: function(q, row){
					var opts = $(this).combobox('options');
					var str=q.toUpperCase()
					var LocDesc=row[opts.textField]
					var LocAlias=row["LocAlias"]
					if(LocDesc.toUpperCase().indexOf(str)>=0) return true
					if(LocAlias.toUpperCase().indexOf(str)>=0) return true
					return false;
				}*/	
			  }
			  }
			},{ field: 'RecLocId', title: '', width: 1,hidden:true
			},
			{ field: 'RowIndex', title: '', width: 1,hidden:true
			},
			{ field: 'DHCIAInstr', title: '�÷�', width: 120, resizable: true,
			  editor : {
				  type : 'combobox',
				  options : {
					mode:'remote',
					valueField:'InstrRowID',   
					textField:'InstrDesc',
					url:$URL+"?ClassName=DHCDoc.DHCDocConfig.InstrArcim&QueryName=FindInstr&InstrAlias=",
					onBeforeLoad:function(param){
						if (param['q']) {
							var desc=param['q'];
						}else{
							var desc="";
						}
						param = $.extend(param,{InstrAlias:desc});
					},onSelect:function(record) {
						var rows=PageLogicObj.m_AppendItemInItemCatDataGrid.datagrid("selectRow",editRow).datagrid("getSelected");
                        if(rows)rows.DHCIAInstrId=record.InstrRowID
						
					},onChange:function(newValue, oldValue) {
						if (newValue==""){
							var rows=PageLogicObj.m_AppendItemInItemCatDataGrid.datagrid("selectRow",editRow).datagrid("getSelected");
                        	if(rows)rows.DHCIAInstrId="";
						}
					},
					loadFilter: function(data){
						return data['rows'];
					}	
				  }
			  }
			},
			{ field: 'DHCIAInstrId', title: '', width: 1,hidden:true},
			{field:'Dose',title:'���μ���',width:70,editor : {type : 'text'}},
			{field:'DoseUomDR',hidden:true},
			{field:'DoseUom',title:'������λ',width:70,editor:{
					type:'combobox',  
					options:{
						url:$URL+"?ClassName=web.DHCDocItemDefault&QueryName=FindDoseUOM", //PUBLIC_CONSTANT.URL.QUERY_COMBO_URL,
						valueField:'RowId',
						textField:'Desc',
						required:false,
						onBeforeLoad:function(param){
							var ARCIMDR=""
							var editors = PageLogicObj.m_AppendItemInItemCatDataGrid.datagrid('getEditors', editRow); 
							if (editors[0]){
								var ARCIMDR=editors[0].target.combogrid('getValue');
							}
							if (ARCIMDR == undefined){
								ARCIMD="";
							}
							if ((ARCIMDR=="")||(ARCIMDR.indexOf("||")==-1)) {
								var ARCIMDR=PageLogicObj.m_AppendItemInItemCatDataGrid.datagrid("getData").rows[editRow].ARCIMRowid;
							}
							if (ARCIMDR == undefined){
								ARCIMDR="";
							}
							param = $.extend(param,{ARCIMRowid:ARCIMDR,HOSPID:$HUI.combogrid('#_HospList').getValue()});
						},
						loadFilter:function(data){
						    return data['rows'];
						},
						onSelect:function(rec){
							var rows=PageLogicObj.m_AppendItemInItemCatDataGrid.datagrid("selectRow",editRow).datagrid("getSelected");
	                        if (rec) rows.DoseUomDR=rec.RowId;
	                        else  rows.DoseUomDR="";
						},
						onChange:function(newValue, oldValue){
							if (!newValue) newValue="";
							if (newValue==""){
								var rows=PageLogicObj.m_AppendItemInItemCatDataGrid.datagrid("selectRow",editRow).datagrid("getSelected");
								if (rows) rows.DoseUomDR="";
							}
						},
						onHidePanel:function(){
							var rows=PageLogicObj.m_AppendItemInItemCatDataGrid.datagrid("selectRow",editRow).datagrid("getSelected");
							if (!$.isNumeric($(this).combobox('getValue'))) return;
							if (rows) rows.DoseUomDR=$(this).combobox('getValue');
						},
						onLoadSuccess:function(data){
							var editDoseObj=PageLogicObj.m_AppendItemInItemCatDataGrid.datagrid('getEditor', {index:editRow,field:'Dose'});
							if (data.length==0) {
								editDoseObj.target.prop("readonly",true);
								$(this).combobox('disable');
							}else{
								editDoseObj.target.prop("readonly",false);
								$(this).combobox('enable');
							}
						}
					  }
				  },
				  formatter:function(value, record){
					  return record.DoseUom;
				  }
			},
			{field:'SPECCode',hidden:true},
			{field:'SPECDesc',title:'�걾',width:70,editor:{
					type:'combobox',  
					options:{
						url:$URL+"?ClassName=DHCDoc.DHCDocConfig.Items&QueryName=FindSpecList",
						valueField:'SPECCode',
						textField:'SPECDesc',
						required:false,
						onBeforeLoad:function(param){
							var ARCIMDR=""
							var editors = PageLogicObj.m_AppendItemInItemCatDataGrid.datagrid('getEditors', editRow); 
							if (editors[0]){
								var ARCIMDR=editors[0].target.combogrid('getValue');
							}
							if (ARCIMDR == undefined){
								ARCIMD="";
							}
							if ((ARCIMDR=="")||(ARCIMDR.indexOf("||")==-1)) {
								var ARCIMDR=PageLogicObj.m_AppendItemInItemCatDataGrid.datagrid("getData").rows[editRow].ARCIMRowid;
							}
							if (ARCIMDR == undefined){
								ARCIMDR="";
							}
							param = $.extend(param,{ArcimRowid:ARCIMDR,HospId:$HUI.combogrid('#_HospList').getValue()});
						},
						loadFilter:function(data){
						    return data['rows'];
						},
						onSelect:function(rec){
							var rows=PageLogicObj.m_AppendItemInItemCatDataGrid.datagrid("selectRow",editRow).datagrid("getSelected");
							if (rec) {
		                        rows.SPECCode=rec.SPECCode;
	                        }else{
		                        rows.SPECCode="";
		                    }
						},
						onChange:function(newValue, oldValue){
							if (!newValue) newValue="";
							if (newValue==""){
								var rows=PageLogicObj.m_AppendItemInItemCatDataGrid.datagrid("selectRow",editRow).datagrid("getSelected");
								if (rows) rows.SPECCode="";
							}
						},
						onHidePanel:function(){
							var rows=PageLogicObj.m_AppendItemInItemCatDataGrid.datagrid("selectRow",editRow).datagrid("getSelected");
							if (!$.isNumeric($(this).combobox('getValue'))) return;
							if (rows) rows.SPECCode=$(this).combobox('getValue');
						},
						onLoadSuccess:function(data){
							for (var i = 0; i < data.length; i++) {
								if (data[i].SPECdefault=="Y"){
									$(this).combobox('select',data[i].SPECCode);
									}
							}
							if (data.length==0) {
								$(this).combobox('disable');
							}else{
								$(this).combobox('enable');
							}
						}
					  }
				  },
				  formatter:function(value, record){
					  return record.SPECDesc;
				  }
			},
			{ field: 'LimitAdmType', title: '���ƾ�������', width: 100,
			  editor :{  
				   type:'combobox',  
				   options:{
					   valueField:'ID',
					   textField:'Desc',
					   multiple:true,
					   rowStyle:'checkbox',
					   data:[{"ID":"����","Desc":"����"},{"ID":"סԺ","Desc":"סԺ"},{"ID":"����","Desc":"����"},{"ID":"���","Desc":"���"},{"ID":"������","Desc":"������"}]  ,
					   loadFilter: function(data){
						   var data=[{"ID":"����","Desc":"����"},{"ID":"סԺ","Desc":"סԺ"},{"ID":"����","Desc":"����"},{"ID":"���","Desc":"���"},{"ID":"������","Desc":"������"}]  
						   return data;
					   }
					 }
				  }
		   }
			
		 ]];
	var AppendItemInItemCatDataGrid=$("#tabAppendItemInItemCat").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:false,
		pagination : true,  
		pageSize: 20,
		pageList : [20,100,200],
		idField:'DHCICARowid',
		columns :Columns,
		toolbar:toolBar,
		onDblClickRow:function(rowIndex,rowData){
			if (editRow!= undefined){
				$.messager.alert("��ʾ","�����ڱ༭����,��ȡ���༭�򱣴�!");
				return false;
			}
			editRow=rowIndex;
			PageLogicObj.m_AppendItemInItemCatDataGrid.datagrid("beginEdit", rowIndex);
		},
		onLoadSuccess:function(data){
			editRow = undefined;
			AppendItemInItemCatDataGrid.datagrid("unselectAll");
		}
	}).datagrid({loadFilter:DocToolsHUI.lib.pagerFilter});
	AppendItemInItemCatDataGrid.datagrid('loadData',{"total":0,"rows":[]});
	return AppendItemInItemCatDataGrid;
}
function SaveClickHandle(){
	if (editRow != undefined) {
		var ItemSubCat=getValue('List_ItemCat');
		if (ItemSubCat==""){
			$.messager.alert('��ʾ',"����ѡ��ҽ������!");
			return false;
		}
		var rows=PageLogicObj.m_AppendItemInItemCatDataGrid.datagrid("selectRow",editRow).datagrid("getSelected");
		var editors = PageLogicObj.m_AppendItemInItemCatDataGrid.datagrid('getEditors', editRow);
		var ARCIMRowid = rows.ARCIMRowid;
		if(typeof(ARCIMRowid)=="undefined"){
			ARCIMRowid=""
		}
		if(ARCIMRowid==""){
			$.messager.alert('��ʾ',"��ѡ��ҽ����");
			return false;
		};
		var Qty = editors[1].target.val();
		if(Qty==""){
			$.messager.alert('��ʾ',"����������");
			return false;
		};
		var r = /^\+?[1-9][0-9]*$/;
		if(!r.test(Qty)){
			$.messager.alert('��ʾ',"����ֻ��Ϊ������!");
			return false;
		}
		var LocId=rows.LocId;
		var RecLocId=rows.RecLocId;
		var DHCIAInstrId=rows.DHCIAInstrId;
		if(typeof(LocId)=="undefined"){
			LocId=""
		}
		if(typeof(RecLocId)=="undefined"){
			RecLocId=""
		}
		if(typeof(DHCIAInstrId)=="undefined"){
			DHCIAInstrId=""
		}
		var DHCICARowid=rows.DHCICARowid;
		if(typeof(DHCICARowid)=="undefined"){
			DHCICARowid=""
		}
		var Dose=editors[5].target.val();
		var DoseUomDR=rows.DoseUomDR;
		var SPECCode=rows.SPECCode;
		var LimitAdmType=editors[8].target.combobox('getValues');
		var ExpStr=Dose+"^"+DoseUomDR+"^"+SPECCode+"^"+LimitAdmType;
		$.cm({
			ClassName:"DHCDoc.DHCDocConfig.AppendItemInItemCat",
			MethodName:"save",
			DHCICARowid:DHCICARowid,
			ItemSubCat:getValue('List_ItemCat'),
			ARCIMRowid:ARCIMRowid, Qty:Qty, LocId:LocId, RecLocId:RecLocId,DHCIAInstrId:DHCIAInstrId,
			ExpStr:ExpStr,
			HospId:$HUI.combogrid('#_HospList').getValue()
		},function(rtn){
			if (rtn=="0"){
				$.messager.popover({msg: '����ɹ�!',type:'success'});
				AppendItemInItemCatDataGridLoad();
			}else if(rtn=="-1"){
				$.messager.alert("��ʾ","����ʧ��!��¼�ظ�!");
			}else if(rtn=="-2"){
				$.messager.alert('��ʾ',"������������ѡ����Ч��ҽ����!");
			}else{
		       $.messager.alert('��ʾ',"����ʧ��:"+rtn);
	        }
		});
	 }
}
function AppendItemInItemCatDataGridLoad(){
	var ItemCatDr=getValue('List_ItemCat');
	if (ItemCatDr==""){
		//$.messager.alert('��ʾ',"����ѡ��ҽ������!");
		//return false;
		PageLogicObj.m_AppendItemInItemCatDataGrid.datagrid("uncheckAll").datagrid('loadData',{"total":0,"rows":[]});
		return;
	}
	if (editRow!= undefined){
		PageLogicObj.m_AppendItemInItemCatDataGrid.datagrid("rejectChanges");
	}
	$.q({
	    ClassName : "DHCDoc.DHCDocConfig.AppendItemInItemCat",
	    QueryName : "GetAppendItemInItemCat",
	    ItemSubCat:ItemCatDr,
	    HospId:$HUI.combogrid('#_HospList').getValue(),
	    Pagerows:PageLogicObj.m_AppendItemInItemCatDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		editRow = undefined;
		PageLogicObj.m_AppendItemInItemCatDataGrid.datagrid("uncheckAll").datagrid('loadData',GridData);
	}); 
}
function getValue(id){
	var className=$("#"+id).attr("class")
	if(typeof className =="undefined"){
		return $("#"+id).val()
	}
	if(className.indexOf("hisui-lookup")>=0){
		var txt=$("#"+id).lookup("getText")
		//����Ŵ��ı����ֵΪ��,�򷵻ؿ�ֵ
		if(txt!=""){ 
			var val=$("#"+id).val()
		}else{
			var val=""
			$("#"+id+"Id").val("")
		}
		return val
	}else if(className.indexOf("hisui-combobox")>=0){
		var val=$("#"+id).combobox("getValue")
		if(typeof val =="undefined") val=""
		return val
	}else if(className.indexOf("hisui-datebox")>=0){
		return $("#"+id).datebox("getValue")
	}else{
		return $("#"+id).val()
	}
	return ""
}