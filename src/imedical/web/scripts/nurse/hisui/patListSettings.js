var GV={
	_CALSSNAME:"Nur.NIS.Service.Base.PatListSettings"
}
var editIndex=undefined;
$(window).load(function() {
	$("#Loading").hide();
});
$(function(){ 
	InitHospList();
	InitEvent();
});
function InitHospList(){
	var hospComp = GenHospComp("Nur_IP_PatListSet");
	hospComp.jdata.options.onSelect = function(e,t){
		$('#menuTab').datagrid("reload");
		clearPatListConfigData();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		Init();
	}
	initTip();
}
function InitEvent(){
	$("#BSave").click(SaveClick);
}
function Init(){
	$(".colorSet-div").css("height",$(window).height()-575);
	$(".signSet-div").css("height",$(".opertionSetPanel").height()-$(".area-div").height()-$(".display-div").height()-$(".colorSet-div").height()-98);
	InitMenuTab();
	InitPatColorTab();
	InitPatSignTab();
}
function InitMenuTab(){
	var ToolBar = [{
        text: '����',
        iconCls: '	icon-add',
        handler: function() {
	        endMenuTabEditing();
	        $('#menuTab').datagrid('insertRow',{
				index: 0,
				row: {
					rowid: '',
					PLSCode: '',
					PLSDesc: ''
				}
			});
			editIndex = 0;
			$('#menuTab').datagrid('selectRow', 0).datagrid('beginEdit', 0);
        }
    },{
        text: 'ɾ��',
        iconCls: 'icon-cancel',
        handler: function() {
	       delMenuSetData();
        }
    },{
        text: '����',
        iconCls: 'icon-save',
        handler: function() {
	       saveMenuSetData();
        }
    }];
	$('#menuTab').datagrid({
		toolbar :ToolBar,
		border:false,
        url: $URL,
        singleSelect: true,
        bodyCls:'panel-body-gray',
        queryParams: {
            ClassName: GV._CALSSNAME,
            QueryName: "getMenuList"
        },
        idField:'rowid',
        columns: [[
	        {
	           field: "PLSCode",title: "����",width: 140,
	            editor: {type: 'text'}
	        },
			{ field: 'PLSDesc',title: '����',  width: 143, 
			  editor: {type: 'text'}
		    }
	    ]],
	    onDblClickRow:function(rowIndex, rowData){
		    if (editIndex != rowIndex) {
		        if (endMenuTabEditing()) {
		            $('#menuTab').datagrid('selectRow', rowIndex).datagrid('beginEdit', rowIndex);
		            editIndex = rowIndex;
		        } else {
		            $('#menuTab').datagrid('selectRow', editIndex);
		        }
		    }
		},
        onClickRow: function (index) {
		    setPatListConfigData();
        },
        onBeforeLoad:function(param){
	        $('#menuTab').datagrid('unselectAll');
	        editIndex = undefined;
	        param.hospId=$HUI.combogrid('#_HospList').getValue();
	    }
    });
}
function endMenuTabEditing(){
	if (editIndex == undefined) { return true; }
	var rows=$('#menuTab').datagrid('getRows');
	if (rows[editIndex]["rowid"]==""){
		$('#menuTab').datagrid('rejectChanges', editIndex);
	}
    $('#menuTab').datagrid('endEdit', editIndex);
    editIndex = undefined;
    return true;
}
function setPatListConfigData(){
	var sel=$('#menuTab').datagrid('getSelected');
	if (sel) {
		$.cm({
			ClassName:GV._CALSSNAME,
			MethodName:"getMenuOpertionSet",
			menuId:sel["rowid"]
		},function(data){
			for (var item in data){
				if ($("#"+item).hasClass("hisui-switchbox")){
					var switchVal=data[item]=="N"?false:true;
					$("#"+item).switchbox("setValue",switchVal);
					if (!switchVal){
						$("#"+item+"Days").numberbox("disable");
					}else{
						$("#"+item+"Days").numberbox("enable");
					}
				}else if($("#"+item).hasClass("hisui-numberbox")){
					$("#"+item).numberbox("setValue",data[item]);
				}
			}			
		})
		$("#patInfoColorTab,#patInfoSignTab").datagrid("reload");
	}else{
		clearPatListConfigData();
	}
}
function clearPatListConfigData(){
	$("#waitingAreaPatShow,#transAreaPatShow,#mulWardPatGroupByWard,#consultPatShow,#transInHospPatShow,#disChargeShow,#patListFold,#transInHospPatExpand,#disChargePatExpand,#loadBedByWardGroup").switchbox("setValue",true);
	$("#consultPatShowDays,#transInHospPatShowDays,#disChargeShowDays,#refreshIntervalTime").numberbox("setValue","").numberbox("enable");
	$("#patInfoColorTab,#patInfoSignTab").datagrid("reload");
}
function saveMenuSetData(){
	if (editIndex == undefined){
	   $.messager.popover({msg:'û����Ҫ����ļ�¼!',type:'error'});
       return false;
	}
	var rows=$('#menuTab').datagrid('getRows');
	var rowid=rows[editIndex]["rowid"];
	var editors=$('#menuTab').datagrid('getEditors',editIndex);
	var PLSCode=editors[0].target.val();
	if (PLSCode ==""){
	   $.messager.popover({msg:'���벻��Ϊ�գ�',type:'error'});
       return false;
	}
	var PLSDesc=editors[1].target.val();
	if (PLSDesc ==""){
	   $.messager.popover({msg:'��������Ϊ�գ�',type:'error'});
       return false;
    }
    $.m({
		ClassName:GV._CALSSNAME,
		MethodName:"handleMenu",
		rowid:rowid,
		code:PLSCode,
		desc:PLSDesc,
		hospId:$HUI.combogrid('#_HospList').getValue(),
		EVENT:"SAVE"
	},function(rtn){
		if (rtn!=0){
			$.messager.popover({msg: '����ʧ�ܣ�'+rtn,type: 'error'});
			return false;
		}else{
			clearPatListConfigData();
			$('#menuTab').datagrid('reload');
		}
	})
}
function delMenuSetData(){
	var sel=$('#menuTab').datagrid("getSelected");
    if (!sel){
       $.messager.popover({msg:'��ѡ����Ҫɾ���ļ�¼��',type:'error'});
       return false;
    }
    $.messager.confirm('ȷ��','�Ƿ�ȷ��ɾ��?',function(r){    
	    if (r){    
	        var rowid=sel["rowid"];
		    $.cm({
				ClassName:GV._CALSSNAME,
				MethodName:"handleMenu",
				rowid:sel["rowid"],
				EVENT:"DELETE"
			},function(rtn){
				if (rtn<0){
					$.messager.popover({msg: 'ɾ��ʧ�ܣ�'+rtn,type: 'error'});
					return false;
				}else{
					var index=$('#menuTab').datagrid("getRowIndex",sel["rowid"]);
					$('#menuTab').datagrid("deleteRow",index);
					clearPatListConfigData();
				}
			})   
	    }    
	});
    
}
function InitPatColorTab(){
	$("#patInfoColorTab").datagrid({
		rownumbers:true,
        url: $URL,
        height:$(".colorSet-div").height() - 29,
        queryParams: {
            ClassName: GV._CALSSNAME,
            QueryName: 'getPatInfoColorSet'
        },
        bodyCls:'panel-header-gray',
        columns: [[
            {
                field: 'PLCSName', title: '��Ŀ����', width: 120,
                editor:{
	                type: 'validatebox',
	                options: {
	                    required: true
	                }
                }
            },
            {
                field: 'PLCSExpress', title: '���ʽ', width: 255,
                editor:{
	                type: 'validatebox',
	                options: {
	                    required: true
	                }
                }
            },
            {
                field: 'PLCSFontColor', title: '������ɫ', width: 70,
                editor:{
	                type: 'text',
	                options: {
	                    required: true
	                }
                },
                styler: function(value,row,index){				
					return 'background-color:'+value;				
				}
            },
            {
                field: 'PLCSValidLocs', title: '���÷�Χ', width: 130,
                editor: {
                    type: 'combobox',
                    options: {
                        valueField: 'wardid',
                        textField: 'warddesc',
                        multiple:true,
                        defaultFilter: 4,
                        url:$URL+"?ClassName=Nur.NIS.Service.Base.Ward&QueryName=GetallWardNew&bizTable=Nur_IP_Question&rows=99999&ResultSetType=array",
                        onSelect: function (record) {
                            
                        },
                        onBeforeLoad:function(param){
	                        param.hospid=$HUI.combogrid('#_HospList').getValue();
	                    }
                    }
                },
                formatter: function (value, row) {
	                return row["PLCSValidLocsDesc"];
	            }
            },
            {
                field: 'PLCSInValidLocs', title: '�����÷�Χ', width: 130,
                editor: {
                    type: 'combobox',
                    options: {
                        valueField: 'wardid',
                        textField: 'warddesc',
                        multiple:true,
                        defaultFilter: 4,
                        url:$URL+"?ClassName=Nur.NIS.Service.Base.Ward&QueryName=GetallWardNew&bizTable=Nur_IP_Question&rows=99999&ResultSetType=array",
                        onSelect: function (record) {
                            
                        },
                        onBeforeLoad:function(param){
	                        param.hospid=$HUI.combogrid('#_HospList').getValue();
	                    }
                    }
                },
                formatter: function (value, row) {
	                return row["PLCSInValidLocsDesc"];
	            }
            },
            {
                field: 'PLCSActive', title: '�Ƿ�����', width: 70,
                formatter: function (value, row) {
	                if (value=="Y") {
		                return "��";
		            }else if(value=="N"){
			            return "��"
			        }else{
				        return "";
				    }
                },
                editor: {
                    type: 'combobox',
                    options: {
	                    required: true,
                        valueField: 'value',
                        textField: 'desc',
                        data: [
                            { value: 'Y', desc: '��' },
                            { value: 'N', desc: '��' },
                        ]
                    }
                }
            },
            { field: 'rowid', title: '����', width: 70, formatter: function(val, row, index){
	            var saveBtn = '<a href="#this" class="savecls" onclick="savePatInfoColorSet(' + (index) + ')"></a>';
                var deleteBtn = '<a href="#this" class="deletecls" onclick="delPatInfoColorSet(\'' + (row.rowid) + '\')"></a>'
                return saveBtn + " " + deleteBtn 
	        } }
        ]],
        onDblClickRow: function (index,row) {
	        var menuId=getSelMenuId();
	        if (menuId==""){
		        $.messager.popover({ msg: '����ѡ�����ɸѡ��Χ��', type: 'error' });
				return false;
		    }
	        if (editPatInfoColorSetIndex != index) {
		        if(editPatInfoColorSetIndex !=undefined){
			        $('#patInfoColorTab').datagrid('endEdit', editPatInfoColorSetIndex);//.datagrid('rejectChanges', editPatInfoColorSetIndex);
				}
	            $('#patInfoColorTab').datagrid('selectRow', index).datagrid('beginEdit', index);
	            editPatInfoColorSetIndex = index;
	            var ed = $('#patInfoColorTab').datagrid('getEditor', {index:editPatInfoColorSetIndex,field:'PLCSFontColor'});
				$(ed.target).color({
					required: true,
					editable:true,
					width:70,
					height:30
				});
				var ed = $('#patInfoColorTab').datagrid('getEditor', {index:editPatInfoColorSetIndex,field:'PLCSValidLocs'});
				if (row["PLCSValidLocs"]){
					$(ed.target).combobox("setValues",row["PLCSValidLocs"].split("^"));
				}else{
					$(ed.target).combobox("setValues","");
				}
				var ed = $('#patInfoColorTab').datagrid('getEditor', {index:editPatInfoColorSetIndex,field:'PLCSInValidLocs'});
				if (row["PLCSInValidLocs"]){
					$(ed.target).combobox("setValues",row["PLCSInValidLocs"].split("^"));
				}else{
					$(ed.target).combobox("setValues","");
				}
		    }
        },
        onLoadSuccess: function (data) {
	        $('#patInfoColorTab').datagrid('appendRow', { rowid: '', PLCSName: '', PLCSExpress: '', PLCSFontColor: '', PLCSValidLocs: '', PLCSInValidLocs: '', PLCSActive: ''});
	        $('.savecls').linkbutton({ text: '', plain: true, iconCls: 'icon-save' });
	        $('.deletecls').linkbutton({ text: '', plain: true, iconCls: 'icon-cancel' });
        },
        onBeforeLoad:function(param){
	        if (editPatInfoColorSetIndex!=undefined){
		        $('#patInfoColorTab').datagrid('endEdit', editPatInfoColorSetIndex);
		        editPatInfoColorSetIndex = undefined;
		    }
	        $('#patInfoColorTab').datagrid('unselectAll');
	        param.menuId=getSelMenuId();
	    }
    });
}
function getSelMenuId(){
	var sel=$('#menuTab').datagrid('getSelected');
    if (sel) {
        return sel["rowid"];
    }
    return "";
}
function savePatInfoColorSet(index){
	var menuId=getSelMenuId();
    if (menuId==""){
        $.messager.popover({ msg: '����ѡ�����ɸѡ��Χ��', type: 'error' });
		return false;
    }
    var rows = $('#patInfoColorTab').datagrid('getRows');
    var row = rows[index];
    var NullValColumnArr=[];
    var editors=$('#patInfoColorTab').datagrid('getEditors',index);
    for (var k=0;k<editors.length;k++){
	    var field=editors[k].field;
	    var fieldOpts = $('#patInfoColorTab').datagrid('getColumnOption',field);
	    if (fieldOpts.editor.type=="combobox") {
		    if (fieldOpts.editor.options.multiple){
			    row[field]=$(editors[k].target).combobox("getValues").join("^");
			}else{
				row[field]=$(editors[k].target).combobox("getValue");
			}
		}else if(field=="PLCSFontColor"){
			row[field]=$.trim($(editors[k].target).color("getValue"));
		}else{
			row[field]=$.trim($(editors[k].target).val());
		}
	    if (fieldOpts.editor.options){
			if ((fieldOpts.editor.options.required)&&(!row[field])){
				NullValColumnArr.push(fieldOpts.title);
			}
		}
	}
	if (NullValColumnArr.length>0){
		$.messager.alert("��ʾ",NullValColumnArr.join("��")+"����Ϊ�գ�");
		return false;
	}
    var saveObj={
	    menuId:menuId,
	    colorSetId:row["rowid"],
		PLCSDel:0
	}
	$.extend(saveObj,row);
    var SaveDataArr=[];
    SaveDataArr.push(saveObj);
    $m({
        ClassName: GV._CALSSNAME,
        MethodName: 'handlePatInfoColorSet',
        SaveDataArr:JSON.stringify(SaveDataArr),
        EVENT:"SAVE"
    }, function (txtData) {
        if (txtData == 0) {
            $.messager.popover({ msg: '����ɹ���', type: 'success'});
            $('#patInfoColorTab').datagrid('endEdit', editPatInfoColorSetIndex);
            $('#patInfoColorTab').datagrid('reload');
        }else{
	        $.messager.popover({ msg: '����ʧ�ܣ�'+txtData, type: 'error'});
	    }
    })
}
function delPatInfoColorSet(rowId){
	$.messager.confirm('ȷ��','ȷ���Ƿ�ɾ����',function(r){    
	    if (r){    
	        var SaveDataArr=[rowId];
			$m({
		        ClassName: GV._CALSSNAME,
		        MethodName: 'handlePatInfoColorSet',
		        SaveDataArr:JSON.stringify(SaveDataArr),
		        EVENT:"DELETE"
		    }, function (txtData) {
		        if (txtData == 0) {
		            $.messager.popover({ msg: 'ɾ���ɹ���', type: 'success'});
		            $('#patInfoColorTab').datagrid('reload');
		        }
		    })  
	    }    
	});
}
var editPatInfoColorSetIndex = undefined;
function InitPatSignTab(){
	$("#patInfoSignTab").datagrid({
		height:$(".signSet-div").height()-30,
        url: $URL,
        queryParams: {
            ClassName: GV._CALSSNAME,
            QueryName: 'getPatInfoSignSet'
        },
        bodyCls:'panel-header-gray',
        columns: [[
        	{
                field: 'PLSSSeqNo', title: '˳��', width: 45,
                editor:{
	                type: 'numberbox'
                }
            },
            {
                field: 'PLSSName', title: '��Ŀ����', width: 120,
                editor:{
	                type: 'validatebox',
	                options: {
	                    required: true
	                }
                }
            },
            {
                field: 'PLSSType', title: '����', width: 120,
                formatter: function (value, row) {
				    return row["PLSSTypeDesc"]
                },
                editor: {
                    type: 'combobox',
                    options: {
	                    editable:false,
	                    required: true,
                        valueField: 'value',
                        textField: 'text',
                        url:$URL+"?ClassName=Nur.NIS.Common.QueryBrokerNew&MethodName=GetOptionOfProperty&className=CF.NUR.NIS.PatListSignSet&propertyName=PLSSType",
                        onSelect: function (rec) {
	                        PLSSTypeChange(rec.value);
                        }
                    }
                }
            },
            {
                field: 'PLSSExpress', title: '��ʶ���ʽ', width: 255,
                editor:{
	                type: 'validatebox',
	                options: {
	                    required: true
	                }
                }
            },
            {
                field: 'PLSSBackGroundColor', title: '������ɫ', width: 70,
                editor:{
	                type: 'text',
	                options: {
	                    required: true
	                }
                },
                styler: function(value,row,index){				
					return 'background-color:'+value;				
				}
            },
            {
                field: 'PLSSFontColor', title: '������ɫ', width: 70,
                editor:{
	                type: 'text',
	                options: {
	                    required: true
	                }
                },
                styler: function(value,row,index){				
					return 'background-color:'+value;				
				}
            },
            {
                field: 'PLSSIcon', title: 'ͼ�궨��', width: 100,
                editor:{
	                type: 'combobox',
	                options: {
	                    required: true,
                        valueField: 'HIDDEN',
                        textField: 'Description',
                        url:$URL+"?ClassName=Nur.NIS.Service.Base.PatListSettings&QueryName=getIconList&rows=99999",
                        onBeforeLoad: function(param){
							param.desc = param["q"];
						},
						loadFilter:function(data){
							return data["rows"];
						}
                    }
                },
                formatter: function (value, row) {
                	return row["PLSSIconDesc"];
                }
            },
            {
                field: 'PLSSFilter', title: '�Ƿ�ɸѡ', width: 70,
                formatter: function (value, row) {
                    if (value=="Y") {
		                return "��";
		            }else if(value=="N"){
			            return "��"
			        }else{
				        return "";
				    }
                },
                editor: {
                    type: 'combobox',
                    options: {
	                    required: true,
                        valueField: 'value',
                        textField: 'desc',
                        data: [
                            { value: 'Y', desc: '��' },
                            { value: 'N', desc: '��' }
                        ]
                    }
                }
            },
            {
                field: 'PLSSShow', title: '�Ƿ���ʾ', width: 70,
                formatter: function (value, row) {
                    if (value=="Y") {
		                return "��";
		            }else if(value=="N"){
			            return "��"
			        }else{
				        return "";
				    }
                },
                editor: {
                    type: 'combobox',
                    options: {
	                    required: true,
                        valueField: 'value',
                        textField: 'desc',
                        data: [
                            { value: 'Y', desc: '��' },
                            { value: 'N', desc: '��' }
                        ]
                    }
                }
            },
            {
                field: 'PLSSValidLocs', title: '���÷�Χ', width: 130,
                editor: {
                    type: 'combobox',
                    options: {
                        valueField: 'wardid',
                        textField: 'warddesc',
                        multiple:true,
                        defaultFilter: 4,
                        url:$URL+"?ClassName=Nur.NIS.Service.Base.Ward&QueryName=GetallWardNew&bizTable=Nur_IP_Question&rows=99999&ResultSetType=array",
                        onSelect: function (record) {
                            
                        },
                        onBeforeLoad:function(param){
	                        param.hospid=$HUI.combogrid('#_HospList').getValue();
	                    }
                    }
                },
                formatter: function(val, row, index){
	                return row["PLSSValidLocsDesc"];
	            }
            },
            {
                field: 'PLSSInValidLocs', title: '�����÷�Χ', width: 130,
                editor: {
                    type: 'combobox',
                    options: {
                        valueField: 'wardid',
                        textField: 'warddesc',
                        multiple:true,
                        defaultFilter: 4,
                        url:$URL+"?ClassName=Nur.NIS.Service.Base.Ward&QueryName=GetallWardNew&bizTable=Nur_IP_Question&rows=99999&ResultSetType=array",
                        onSelect: function (record) {
                            
                        },
                        onBeforeLoad:function(param){
	                        param.hospid=$HUI.combogrid('#_HospList').getValue();
	                    }
                    }
                },
                formatter: function(val, row, index){
	                return row["PLSSInValidLocsDesc"];
	            }
            },
            {
                field: 'PLSSActive', title: '�Ƿ�����', width: 70,
                formatter: function (value, row) {
                    if (value=="Y") {
		                return "��";
		            }else if(value=="N"){
			            return "��"
			        }else{
				        return "";
				    }
                },
                editor: {
                    type: 'combobox',
                    options: {
	                    required: true,
                        valueField: 'value',
                        textField: 'desc',
                        data: [
                            { value: 'Y', desc: '��' },
                            { value: 'N', desc: '��' },
                        ]
                    }
                }
            },
            { field: 'rowid', title: '����', width: 70, formatter: function(val, row, index){
	            var saveBtn = '<a href="#this" class="savecls" onclick="savePatInfoSignSet(' + (index) + ')"></a>';
                var deleteBtn = '<a href="#this" class="deletecls" onclick="delPatInfoSignSet(\'' + (row.rowid) + '\')"></a>'
                return saveBtn + " " + deleteBtn
	        } }
        ]],
        onDblClickRow: function (index,row) {
	        var menuId=getSelMenuId();
	        if (menuId==""){
		        $.messager.popover({ msg: '����ѡ�����ɸѡ��Χ��', type: 'error' });
				return false;
		    }
	        if (editPatInfoSignSetIndex != index) {
		        if(editPatInfoSignSetIndex !=undefined){
			        $('#patInfoSignTab').datagrid('endEdit', editPatInfoSignSetIndex).datagrid('rejectChanges', editPatInfoSignSetIndex);
				}
	            $('#patInfoSignTab').datagrid('selectRow', index).datagrid('beginEdit', index);
	            editPatInfoSignSetIndex = index;
	            var ed = $('#patInfoSignTab').datagrid('getEditor', {index:editPatInfoSignSetIndex,field:'PLSSFontColor'});
				$(ed.target).color({
					required: true,
					editable:true,
					width:70,
					height:30
				});
				var ed = $('#patInfoSignTab').datagrid('getEditor', {index:editPatInfoSignSetIndex,field:'PLSSBackGroundColor'});
				$(ed.target).color({
					required: true,
					editable:true,
					width:70,
					height:30
				});
				var ed = $('#patInfoSignTab').datagrid('getEditor', {index:editPatInfoSignSetIndex,field:'PLSSValidLocs'});
				if (row["PLSSValidLocs"]){
					$(ed.target).combobox("setValues",row["PLSSValidLocs"].split("^"));
				}else{
					$(ed.target).combobox("setValues","");
				}
				var ed = $('#patInfoSignTab').datagrid('getEditor', {index:editPatInfoSignSetIndex,field:'PLSSInValidLocs'});
				if (row["PLSSInValidLocs"]){
					$(ed.target).combobox("setValues",row["PLSSInValidLocs"].split("^"));
				}else{
					$(ed.target).combobox("setValues","");
				}
				PLSSTypeChange(row["PLSSType"]);
		    }
        },
        onLoadSuccess: function (data) {
	        if ((data.total==0)||(data.total>=1)&&(data.rows[data.total-1].rowid)) { 
	        	$('#patInfoSignTab').datagrid('appendRow', { rowid: '', PLSSName: '', PLSSExpress: '', PLSSFontColor: '', PLSSValidLocs: '', PLSSInValidLocs: '', PLSSActive: '',PLSSIcon:''});
	        }
	        $('.savecls').linkbutton({ text: '', plain: true, iconCls: 'icon-save' });
	        $('.deletecls').linkbutton({ text: '', plain: true, iconCls: 'icon-cancel' });
        },
        onBeforeLoad:function(param){
	        if (editPatInfoSignSetIndex!=undefined){
		        $('#patInfoSignTab').datagrid('endEdit', editPatInfoSignSetIndex);
		        editPatInfoSignSetIndex = undefined
		    }
	        $('#patInfoSignTab').datagrid('unselectAll');
	        param.menuId=getSelMenuId();
	    }
    });
}
function savePatInfoSignSet(index){
	var menuId=getSelMenuId();
    if (menuId==""){
        $.messager.popover({ msg: '����ѡ�����ɸѡ��Χ��', type: 'error' });
		return false;
    }
	var NullValColumnArr=[],SeqNoArr=[];
    var rows = $('#patInfoSignTab').datagrid('getRows');
    for (var i=0;i<rows.length;i++){
	    if (i==index) continue;
	    if (rows[i]["PLSSSeqNo"]!=""){
	    	SeqNoArr[rows[i]["PLSSSeqNo"]]=1;
	    }
	}
    var row = rows[index];
    var editors=$('#patInfoSignTab').datagrid('getEditors',index);
	for (var k=0;k<editors.length;k++){
	    var field=editors[k].field;
	    var fieldOpts = $('#patInfoSignTab').datagrid('getColumnOption',field);
	    if (fieldOpts.editor.type=="combobox") {
		    if (fieldOpts.editor.options.multiple){
			    row[field]=$(editors[k].target).combobox("getValues").join("^");
			}else{
				row[field]=$(editors[k].target).combobox("getValue");
			}
		}else if((field=="PLSSFontColor")||(field=="PLSSBackGroundColor")){
			row[field]=$.trim($(editors[k].target).color("getValue"));
		}else if(fieldOpts.editor.type=="numberbox"){
			row[field]=$.trim($(editors[k].target).numberbox("getValue"));
			if (SeqNoArr[row[field]]){
				$.messager.popover({ msg: '����ظ���', type: 'error' });
				return false;
			}else if(row[field]!=""){
				SeqNoArr[row[field]]=1;
			}
		}else{
			row[field]=$.trim($(editors[k].target).val());
		}
	    if (fieldOpts.editor.options){
			if ((fieldOpts.editor.options.required)&&(!row[field])){
				NullValColumnArr.push(fieldOpts.title);
			}
		}
	}
	if (NullValColumnArr.length>0){
		$.messager.alert("��ʾ",NullValColumnArr.join("��")+"����Ϊ�գ�");
		return false;
	}
    var saveObj={
	    menuId:menuId,
	    signSetId:row["rowid"],
		PLSSDel:0
	}
	$.extend(saveObj,row);
    var SaveDataArr=[];
    SaveDataArr.push(saveObj);
    $m({
        ClassName: GV._CALSSNAME,
        MethodName: 'handlePatInfoSignSet',
        SaveDataArr:JSON.stringify(SaveDataArr),
        EVENT:"SAVE"
    }, function (txtData) {
        if (txtData == 0) {
            $.messager.popover({ msg: '����ɹ���', type: 'success'});
            $('#patInfoSignTab').datagrid('reload');
        }else{
	        $.messager.popover({ msg: '����ʧ�ܣ�'+txtData, type: 'error'});
	    }
    })
}
function delPatInfoSignSet(rowId){
	$.messager.confirm('ȷ��','ȷ���Ƿ�ɾ����',function(r){    
	    var SaveDataArr=[rowId];
		$m({
	        ClassName: GV._CALSSNAME,
	        MethodName: 'handlePatInfoSignSet',
	        SaveDataArr:JSON.stringify(SaveDataArr),
	        EVENT:"DELETE"
	    }, function (txtData) {
	        if (txtData == 0) {
	            $.messager.popover({ msg: 'ɾ���ɹ���', type: 'success', timeout: 2000 });
	            $('#patInfoSignTab').datagrid('reload');
	        }
	    })    
    });
}
var editPatInfoSignSetIndex = undefined;
function SaveClick(){
	var menuId=getSelMenuId();
	if (menuId==""){
		$.messager.popover({ msg: '����ѡ�����ɸѡ��Χ��', type: 'error' });
		return false;
	}
	var obj={
		menuId:menuId,
		PLSWaitingAreaPatShow:$("#waitingAreaPatShow").switchbox("getValue")?"Y":"N",
		PLSConsultPatShow:$("#consultPatShow").switchbox("getValue")?"Y":"N",
		PLSConsultPatShowDays:$("#consultPatShowDays").numberbox("getValue"),
		PLSTransInHospPatShow:$("#transInHospPatShow").switchbox("getValue")?"Y":"N",
		PLSTransInHospPatShowDays:$("#transInHospPatShowDays").numberbox("getValue"),
		PLSDisChargeShow:$("#disChargeShow").switchbox("getValue")?"Y":"N",
		PLSDisChargeShowDays:$("#disChargeShowDays").numberbox("getValue"),
		PLSPatListFold:$("#patListFold").switchbox("getValue")?"Y":"N",
		PLSRefreshIntervalTime:$("#refreshIntervalTime").numberbox("getValue"),
		PLSTransAreaPatShow:$("#transAreaPatShow").switchbox("getValue")?"Y":"N",
		PLSMulWardPatGroupByWard:$("#mulWardPatGroupByWard").switchbox("getValue")?"Y":"N",
		PLSTransInHospPatExpand:$("#transInHospPatExpand").switchbox("getValue")?"Y":"N",
		PLSDisChargePatExpand:$("#disChargePatExpand").switchbox("getValue")?"Y":"N",
		PLSLoadBedByWardGroup:$("#loadBedByWardGroup").switchbox("getValue")?"Y":"N"
	}
	var SaveDataArr=[obj];
    $m({
        ClassName: GV._CALSSNAME,
        MethodName: 'handleMenuOpertionSet',
        SaveDataArr:JSON.stringify(SaveDataArr)
    }, function (txtData) {
        if (txtData == 0) {
            $.messager.popover({ msg: '����ɹ���', type: 'success'});
        }
    })
}
function switchCheckChange(e,obj){
	var switchId=e.target.id;
	if (obj.value){
		$("#"+switchId+"Days").numberbox("enable");
	}else{
		$("#"+switchId+"Days").numberbox("setValue","").numberbox("disable");
	}
}
function PLSSTypeChange(type){
	if (!type) return;
	var PLSSExpressOpts=$('#patInfoSignTab').datagrid('getColumnOption', 'PLSSExpress');
    var PLSSExpressObj=$("#patInfoSignTab").datagrid('getEditor', {index:editPatInfoSignSetIndex,field:'PLSSExpress'});
    var PLSSBackGroundColorOpts=$('#patInfoSignTab').datagrid('getColumnOption', 'PLSSBackGroundColor');
    var PLSSBackGroundColorObj=$("#patInfoSignTab").datagrid('getEditor', {index:editPatInfoSignSetIndex,field:'PLSSBackGroundColor'});
    var PLSSFontColorObj=$("#patInfoSignTab").datagrid('getEditor', {index:editPatInfoSignSetIndex,field:'PLSSFontColor'});
    var PLSSFontColorOpts=$('#patInfoSignTab').datagrid('getColumnOption', 'PLSSFontColor');
    var PLSSIconObj=$("#patInfoSignTab").datagrid('getEditor', {index:editPatInfoSignSetIndex,field:'PLSSIcon'});
    var PLSSIconOpts=$('#patInfoSignTab').datagrid('getColumnOption', 'PLSSIcon');
    if (type =="Icon"){
        PLSSExpressOpts.editor.options.required=false;
	    PLSSExpressObj.target.validatebox("disableValidation")
        PLSSExpressObj.target[0].value="",PLSSExpressObj.target[0].disabled=true;
        
        PLSSBackGroundColorOpts.editor.options.required=false;
		PLSSBackGroundColorObj.target.color("disableValidation").color("clear").color("disable");
		
		PLSSFontColorOpts.editor.options.required=false;
		PLSSFontColorObj.target.color("disableValidation").color("clear").color("disable");
		
		PLSSIconOpts.editor.options.required=true;
		PLSSIconObj.target.combobox("enableValidation").combobox("enable");
    }else if(type =="Sign"){
        PLSSExpressOpts.editor.options.required=true;
        PLSSExpressObj.target.validatebox("enableValidation");
        PLSSExpressObj.target[0].disabled=false;
        
        PLSSBackGroundColorOpts.editor.options.required=true;
		PLSSFontColorObj.target.color("enableValidation").color("enable");
		
		PLSSBackGroundColorOpts.editor.options.required=true;
		PLSSBackGroundColorObj.target.color("enableValidation").color("enable");
		
		PLSSIconOpts.editor.options.required=false;
		PLSSIconObj.target.combobox("disableValidation").combobox("setValue","").combobox("disable");
    }
    $('#patInfoSignTab').datagrid('validateRow',editPatInfoSignSetIndex);
}
function initTip(){
	$('#areaConfigTip').tooltip({
		position: 'bottom',
		content: '<p>����ҵ����滼���б���������Ƿ���ʾ��</p>'+
				 '<p>ת������������ʾ����ת�ƻ��ߡ�</p>'+
				 '<p>��Ժת�ƣ�������ʾ�����ת�Ʋ����Ļ��ߡ�</p>'+
				 '<p>����/��Ժת��/��Ժ����"��ʾ"��,��������ʾN���ڷ��������Ļ���,��N=0ʱĬ�ϲ�ѯ�����ڷ��������Ļ��ߡ�</p>'
	})
	$("#displayConfigTip").tooltip({
		position: 'bottom',
		content: '<p>Ĭ����ʾ��ʽ�����ƻ����б����չ����ʽ��������Ĭ�Ͻ���ҳ�滼���б�����۵���ʾ��</p>'+
				 '<p>����ҷ�����ʾ������ҵ��������һ����б��Ƿ��տ��ҷ���չʾ��</p>'+
				 '<p>�����б��Զ�ˢ�¼��������ҵ����滼���б���ɫ��ͼ�ꡢ��ʶ�Զ�ˢ�¼��,0��ʾ���Զ�ˢ��</p>'
	})
	$("#colorConfigTip").tooltip({
		position: 'bottom',
		content: '<p>���ƻ����б��ϻ�����Ϣ������ɫ</p>'
	})
	$("#signConfigTip").tooltip({
		position: 'bottom',
		content: '<p>���ƻ����б��ϻ�����Ϣ���ӱ�ʶ��</p>'+
				 '<p>�Ƿ�ɸѡ�����ú����б��ɸѡ���ϸ������Ļ��ߡ�</p>'
	})
	
}