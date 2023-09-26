var commonPhaUrl = "DHCST.COMMONPHA.ACTION.csp";
var thisUrl="dhcpha.inpha.locgroup.action.csp";
var gLocId=session['LOGON.CTLOCID'];
var gUserId=session['LOGON.USERID'];
var gGroupId=session['LOGON.GROUPID'];
var HospId=session['LOGON.HOSPID'];
var gridChkIcon='<i class="fa fa-check" aria-hidden="true" style="color:#17A05D;font-size:18px"></i>'
$(function (){
	InitHospCombo();
	var options={
		url:commonPhaUrl+'?action=GetCtLocDs&HospId='+HospId
	}
	$('#phaLoc').dhcphaEasyUICombo(options);
	InitPhaLocGroupGrid(); //��ʼ���������б�
	InitPhaLocGrid(); //��ʼ�������б�
	$('#btnadd').bind("click",InsertLocGrp);
	$('#btnsave').bind("click",UpdateLocGrp);
	$('#btndelete').bind("click",DeleteLocGrp);
	$('#btnfind').bind("click",QueryLocGrp);
})	
	
//��ʼ��table
function InitPhaLocGroupGrid(){
	//����columns  
	var columns=[[
		{field:"Tdesc",title:'������',width:200},
		{field:"Trowid",title:'Trowid',width:100,hidden:true},
		{field:'Tdisploc',title:'ҩ������',width:200},
		{field:'TdisplocId',title:'ҩ��ID',width:200,hidden:true}	
	]];
	
	//����datagrid   
	$('#locGroupGrid').datagrid({
		border:false,
		striped:true,
		url:thisUrl+'?action=jsQueryLocGroup&HospId='+HospId,
		fit:true,
		//rownumbers:true,
		singleSelect:true,
		columns:columns,
		loadMsg: '���ڼ�����Ϣ...',		
		onDblClickRow:function(rowIndex, rowData){
			var phaloc=rowData.TdisplocId;
			var locgrpdesc=rowData.Tdesc;
			//$('#phaLoc').combobox("setValue",phaloc);
            $("#phaLoc").combobox("loadData", [{RowId:phaloc,Desc:rowData.Tdisploc}]);
            $("#phaLoc").combobox("select",phaloc);
			$('#phaLocGroup').val(locgrpdesc);
		},
		onSelect:function(index,data){ 
			var params=data.Trowid;
			$('#locGrid').datagrid("load",{
				params:params
			});			
		}
	});

}

function InitPhaLocGrid(){
	//����columns
	var columns=[[
		{field:"Trowid",title:'Trowid',width:100,hidden:true},
		{field:"Tdesc",title:'����',width:300},
		{field:'Tselect',title:'ѡ��',width:50,align:'center',
			formatter: function(value,row,index){
				if (value=="Y"){
	        		return gridChkIcon;
	        	}else{
		        //	return '<img src="../scripts/dhcpha/img/cancel.png" border=0/>';
		        }
			}
		}
			
	]];
	
	//����datagrid
	$('#locGrid').datagrid({
		border:false,
		striped:true,
		url:thisUrl+'?action=jsQueryLoc&HospId='+HospId,
		fit:true,
		singleSelect:true,
		columns:columns,
		pagination:true,
		pageSize:30,
		pageList:[30,50,100],
		pagePosition:'bottom',
		loadMsg: '���ڼ�����Ϣ...',
		onLoadSuccess: function(){
			$("#locGrid").datagrid("scrollTo",0);
		},
		onDblClickCell: function (rowIndex, field, value) {
			if (field!="Tselect"){return;}
			var rowdata=$("#locGroupGrid").datagrid('getSelected');
			if (rowdata==null){
				$.messager.alert("��ʾ","����ѡ����Ҫ�޸Ŀ��ҵĿ������б������!","info")	
				return;
			}
			var mrowid=rowdata.Trowid;
			var subrowdata=$("#locGrid").datagrid('getSelected');
			var locid=subrowdata.Trowid;
			var yesflag="Y";
			if (value=="Y"){
				yesflag="N";
			}
			if (yesflag=="Y"){
				var retValue=tkMakeServerCall("web.DHCSTPHAADDLOCGRP","InsertLocGrpItm",locid,mrowid);
				if (retValue==-11){
					$.messager.alert("��ʾ","�ÿ����Ѿ�ά��������������,�����ظ�!","info")
					return;	
				}else if (retValue<0){
					$.messager.alert("��ʾ","����ʧ��,�������:"+retValue,"info")
					return;	
				}
			}else if (yesflag="N"){
				var retValue=tkMakeServerCall("web.DHCSTPHAADDLOCGRP","DeleteLocGrpItm",locid,mrowid);
				if (retValue<0){
					$.messager.alert("��ʾ","����ʧ��,�������:"+retValue,"info");
					return;	
				}
			}
			$('#locGrid').datagrid('updateRow',{
				index: rowIndex,
				row: {Tselect:yesflag}
			});
		}
	});
	
}

function InsertLocGrp(){
	CheckComboVal("phaLoc");
	var locgrpdesc=$('#phaLocGroup').val();
	if (locgrpdesc==""){
		$.messager.alert("��ʾ","����������Ϊ��!","info")		
		return;
	}
	var phalocid=$('#phaLoc').combobox("getValue")||'';
	if (phalocid==''){
		phalocid="";
		$.messager.alert("��ʾ","����Ϊ��!","info")	;
		return;
	}
	var retValue=tkMakeServerCall("web.DHCSTPHAADDLOCGRP","Insert",locgrpdesc,phalocid);
	if (retValue>0){
		$('#locGroupGrid').datagrid('reload');	
	}else if (retValue==-4){
		$.messager.alert("��ʾ","��ǰ�����������Ѵ���,����Ҫ����!","info");	
	}else{
		$.messager.alert("��ʾ","����ʧ��,�������:"+retValue,"info");	
	}
}	
function UpdateLocGrp(){
	CheckComboVal("phaLoc");
	var selectrow=$("#locGroupGrid").datagrid('getSelected');	
	var mrowid="";
	if (selectrow==null){
		$.messager.alert("��ʾ","����ѡ��Ԥ�޸ĵļ�¼!","info");	
		return;
	}else{
		mrowid=selectrow.Trowid;
	}
	var locgrpdesc=$('#phaLocGroup').val();
	if (locgrpdesc==""){
		$.messager.alert("��ʾ","����������Ϊ��!","info")		
		return;
	}
	var phalocid=$('#phaLoc').combobox("getValue")||'';
	if (phalocid==''){
		phalocid="";
		$.messager.alert("��ʾ","����Ϊ��!","info")	
		return;
	}
	var retValue=tkMakeServerCall("web.DHCSTPHAADDLOCGRP","Update",mrowid,locgrpdesc,phalocid);
	if (retValue>0){
		$('#locGroupGrid').datagrid('reload');	
	}else if (retValue==-4){
		$.messager.alert("��ʾ","��ǰ�����������Ѵ���,����Ҫ����!","info");	
	}else{
		$.messager.alert("��ʾ","����ʧ��,�������:"+retValue,"info");	
	}
}	
function DeleteLocGrp(){
	var selectrow=$("#locGroupGrid").datagrid('getSelected');	
	var mrowid="";
	if (selectrow==null){
		$.messager.alert("��ʾ","����ѡ��Ԥɾ���ļ�¼!","info");	
		return;
	}else{
		mrowid=selectrow.Trowid;
	}
	$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����", function (res) {
		if (res) {
			var retValue=tkMakeServerCall("web.DHCSTPHAADDLOCGRP","Delete",mrowid);
			$('#locGroupGrid').datagrid('reload');	
			$('#locGrid').datagrid("load",{
				params:""
			});	
		}
	})
}
function QueryLocGrp(){
	var locgrpdesc=$('#phaLocGroup').val();
	var phalocid=$('#phaLoc').combobox("getValue");
	if ((phalocid==undefined)||(phalocid==null)){
		phalocid="";
	}
	var params=locgrpdesc+"^"+phalocid;
	$('#locGroupGrid').datagrid("load",{
		params:params
	});
	$('#locGrid').datagrid("load",{
		params:""
	});		
}
 
function CheckComboVal(cmbId){
	var $cmb=$("#"+cmbId);
    var valueField = $cmb.combobox("options").valueField;
    var val = $cmb.combobox("getValue"); 
    var allData = $cmb.combobox("getData");
    var result = true;
    for (var i = 0; i < allData.length; i++) {
        if (val == allData[i][valueField]) {
            result = false;
            break;
        }
    }
    if (result) {
        $cmb.combobox("clear");	   
        //$cmb.combobox("reload");	            
    }
}

function InitHospCombo(){
    var genHospObj = DHCSTEASYUI.GenHospComp({tableName:'PHA-IP-LocGrp'});
    if (typeof genHospObj === 'object') {
		//����ѡ���¼�
		$('#_HospList').combogrid("options").onSelect=function(index,record){
			NewHospId=record.HOSPRowId;
			if(NewHospId!=HospId){
				HospId=NewHospId;
			    $('#phaLocGroup').val("");
			    $("#phaLoc").combobox('setValue', "");
				$('#phaLoc').combobox('options').url=commonPhaUrl+'?action=GetCtLocDs&HospId='+HospId;	
				$('#phaLoc').combobox('reload');	
				$('#locGroupGrid').datagrid('options').url=thisUrl+'?action=jsQueryLocGroup&HospId='+HospId;
				$('#locGrid').datagrid('options').url=thisUrl+'?action=jsQueryLoc&HospId='+HospId;
				QueryLocGrp();		
			}
		};
    }
}