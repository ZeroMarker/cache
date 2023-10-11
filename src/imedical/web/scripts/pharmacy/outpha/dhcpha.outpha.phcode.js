/**
 * ģ��:����ҩ��
 * ��ģ��:סԺҩ��-��ҳ-��˵�-����ҩ��ά��
 * createdate:2016-07-07
 * creator: yunhaibao
 */
var commonOutPhaUrl = "DHCST.OUTPHA.ACTION.csp";
var url = "dhcpha.outpha.phcode.action.csp";
var gLocId=session['LOGON.CTLOCID'];
var gUserId=session['LOGON.USERID'];
var gGroupId=session['LOGON.GROUPID'];
var HospId=session['LOGON.HOSPID'];
var gridChkIcon='<i class="fa fa-check" aria-hidden="true" style="color:#17A05D;font-size:18px"></i>'
var combooption = {
	valueField :'RowId',    
	textField :'Desc',
	panelWidth:'150'
}
$(function(){
	InitHospCombo();
	InitPhaLoc();
	InitPhaLocGrid();		
	$('#btnAdd').on('click',function(){
		$('#phcodewin').window({'title':$g("���﷢ҩ����ά������")});
		$('#phcodewin').window('open');
		$("input[type=checkbox][name=chkcondition]").prop('checked',false);
		$("input[name=txtconditon]").val("");
		$("#phaLoc").combobox("setValue","");
		phLocRowId="";
		$("#phaLoc").combobox('enable');
		$("#dispMath").combobox("setValue",1);
	});
	$('#btnUpdate').on('click', btnUpdateHandler);//����޸�
	$('#btnSave').on('click',btnSaveHandler);
	$('#btnCancel').on('click',function(){
		$('#phcodewin').window('close');
	});
	$('#phlocgrid').datagrid("reload") 
});
function InitPhaLoc(){
	var options={
		url:commonOutPhaUrl+'?action=GetUserAllLocDs&gUserId='+gUserId+'&HospId='+HospId
	}
	$('#phaLoc').dhcphaEasyUICombo(options);
}
//��ʼ����ҩ�����б�
function InitPhaLocGrid(){
	//����columns
	var columns=[[
	    {field:'Tphlid',title:'Tphlid',width:50,hidden:true},
        {field:'Tyfid',title:'Tyfid',width:100,hidden:true},
        {field:'Tdesc',title:$g("ҩ������"),width:150},
        {field:'Tyfsf',title:$g("ȡҩ�㷨"),width:100},
        {field:'TCyFlag',title:$g("�в�ҩ"),width:50,align:'center',
        	formatter:function(value,row,index){
	        	if (value==$g("��")){
		        	return gridChkIcon;
	        	}else{
		        //	return '<img src="../scripts/dhcpha/img/cancel.png" border=0/>';
		        }
	        }
        },
        {field:'TAuditFlag',title:$g("�������"),width:55,align:'center',
        	formatter:function(value,row,index){
	        	if (value==$g("��")){
	        		return gridChkIcon;
	        	}else{
		        //	return '<img src="../scripts/dhcpha/img/cancel.png" border=0/>';
		        }
	        }
        },
        {field:'Tbyfs',title:$g("��ǰ��ҩ"),width:55,align:'center',
        	formatter:function(value,row,index){
	        	if (value==$g("��")){
	        		return gridChkIcon;
	        	}else{
		        //	return '<img src="../scripts/dhcpha/img/cancel.png" border=0/>';
		        }
	        }
        },
        {field:'Tpysure',title:$g("��ҩȷ��"),width:55,align:'center',
        	formatter:function(value,row,index){
	        	if (value==$g("��")){
	        		return gridChkIcon;
	        	}else{
		        //	return '<img src="../scripts/dhcpha/img/cancel.png" border=0/>';
		        }
	        }
        },
        {field:'TAutoPyFlag',title:$g("�Զ���ӡ")+'</br>'+$g("�䡡��ҩ"),width:55,align:'center',
        	formatter:function(value,row,index){
	        	if (value==$g("��")){
	        		return gridChkIcon;
	        	}else{
		        //	return '<img src="../scripts/dhcpha/img/cancel.png" border=0/>';
		        }
	        }
        },
        {field:'Tpy',title:$g("��ҩ"),width:55,align:'center',
        	formatter:function(value,row,index){
	        	if (value==$g("��")){
	        		return gridChkIcon;
	        	}else{
		        //	return '<img src="../scripts/dhcpha/img/cancel.png" border=0/>';
		        }
	        }
        },
        {field:'Tfy',title:$g("��ҩ"),width:55,align:'center',hidden:true,
        	formatter:function(value,row,index){
	        	if (value==$g("��")){
	        		return gridChkIcon;
	        	}else{
		        //	return '<img src="../scripts/dhcpha/img/cancel.png" border=0/>';
		        }
	        }
        },
        {field:'TOthLocRet',title:$g("�������ҩ"),width:65,align:'center',
        	formatter:function(value,row,index){
	        	if (value==$g("��")){
	        		return gridChkIcon;
	        	}else{
		        //	return '<img src="../scripts/dhcpha/img/cancel.png" border=0/>';
		        }
	        }
        },
        {field:'TDispMachine',title:$g("��ҩ��"),width:55,align:'center',
        	formatter:function(value,row,index){
	        	if (value==$g("��")){
	        		return gridChkIcon;
	        	}else{
		        //	return '<img src="../scripts/dhcpha/img/cancel.png" border=0/>';
		        }
	        }
        },
        {field:'TSendFlag',title:$g("��������"),width:55,align:'center',
        	formatter:function(value,row,index){
	        	if (value==$g("��")){
	        		return gridChkIcon;
	        	}else{
		        //	return '<img src="../scripts/dhcpha/img/cancel.png" border=0/>';
		        }
	        }
        },
        {field:'TPrintFlag',title:$g("�����ӡ��"),width:65,align:'center',hidden:true,
        	formatter:function(value,row,index){
	        	if (value==$g("��")){
	        		return gridChkIcon;
	        	}else{
		        //	return '<img src="../scripts/dhcpha/img/cancel.png" border=0/>';
		        }
	        }
        },
        {field:'TWinTypeFlag',title:$g("���ڷ���"),width:55,align:'center',hidden:true,
        	formatter:function(value,row,index){
	        	if (value==$g("��")){
	        		return gridChkIcon;
	        	}else{
		        //	return '<img src="../scripts/dhcpha/img/cancel.png" border=0/>';
		        }
	        }
        },
        {field:'TScreenFlag',title:$g("��ʾ��"),width:50,align:'center',
        	formatter:function(value,row,index){
	        	if (value==$g("��")){
	        		return gridChkIcon;
	        	}else{
		        //	return '<img src="../scripts/dhcpha/img/cancel.png" border=0/>';
		        }
	        }
        },
        {field:'TScreenPath',title:$g("��ʾ·��"),width:100}
	]];  
	
   //����datagrid	
   $('#phlocgrid').datagrid({    
        url:url+'?action=QueryPhLocCode',
	    border:false,
	    toolbar:'#btnbar1',
	    singleSelect:true,
	    rownumbers:true,
        columns:columns,
	    singleSelect:true,
	    fitColumns:true,
	    striped:true,
	    queryParams:{
		    HospId : HospId
		},
	    loadMsg: '���ڼ�����Ϣ...',
	    onSelect:function(rowIndex,rowData){
		},
		onLoadSuccess: function(){       	
	    },
	    onLoadError:function(data){
			$.messager.alert($g("����"),$g("��������ʧ��,��鿴������־!"),"warning")
			$('#phlocgrid').datagrid('loadData',{total:0,rows:[]});
			$('#phlocgrid').datagrid('options').queryParams.params = ""; 
		}  
   });
}


//���淢ҩ��������
function btnSaveHandler(){
	var phLocRowId="";
	var winTitle=$("#phcodewin").panel('options').title;
	if (winTitle.indexOf($g("�޸�"))>=0){
		var phalocselect = $("#phlocgrid").datagrid("getSelected");
		if (phalocselect==null){
			$.messager.alert($g("��ʾ"),$g("����ѡ�����޸ĵ���!"),"info");
			return;
		}
		phLocRowId=phalocselect.Tphlid;
	}else if (winTitle.indexOf($g("����"))>=0){
		phLocRowId="";
	}else{
		return;
	}
	var locRowId=$("#phaLoc").combobox("getValue");
	if (($.trim($("#phaLoc").combobox("getValue"))=="")||(locRowId==undefined)){
		locRowId="";
		$.messager.alert($g("��ʾ"),$g("��ҩ���ұ���!"),"info");
		return;
	}
	var dispmath=$("#dispMath").combobox("getValue");
	if ((dispmath=="")||(dispmath==undefined)){
		$.messager.alert($g("��ʾ"),$g("ȡҩ�㷨����!"),"info");
		return;
	}
	var screenpath=$("#screenPath").val();
	var chkpy="0"
	if ($("#chkPY").is(':checked')){
		chkpy="1";
	}
	var chkfy="0"
	if ($("#chkFY").is(':checked')){
		chkfy="1";
	}
	var chktq="0"
	if ($("#chkTQ").is(':checked')){
		chktq="1";
	}
	var chkzcy="0"
	if ($("#chkZCY").is(':checked')){
		chkzcy="1";
	}
	var chksend="0"
	if ($("#chkSend").is(':checked')){
		chksend="1";
	}
	var chkprint="0"
	if ($("#chkPrint").is(':checked')){
		chkprint="1";
	}
	var chkwintype="0"
	if ($("#chkWinType").is(':checked')){
		chkwintype="1";
	}
	var chkmachine="0"
	if ($("#chkMachine").is(':checked')){
		chkmachine="1";
	}
	var chkscreen="0"
	if ($("#chkScreen").is(':checked')){
		chkscreen="1";
	}
	var chksure="0"
	if ($("#chkSure").is(':checked')){
		chksure="1";
	}
	var chkautopy="0"
	if ($("#chkAutoPY").is(':checked')){
		chkautopy="1";
	}
	var chkaudit="N"
	if ($("#chkAudit").is(':checked')){
		chkaudit="Y";
	}
	var chkotherlocret="N"
	if ($("#chkOtherLocRet").is(':checked')){
		chkotherlocret="Y";
	}
	var params=phLocRowId+"^"+locRowId+"^"+chkpy+"^"+chkfy+"^"+dispmath+"^"+chktq
			   +"^"+chkzcy+"^"+gUserId+"^"+chksend+"^"+chkprint+"^"+chkwintype
			   +"^"+chkmachine+"^"+chkscreen+"^"+screenpath+"^"+chksure+"^"+chkautopy
			   +"^"+chkaudit+"^"+chkotherlocret	  
	var saveret=tkMakeServerCall("web.DHCOUTPHA.PhCode","SavePhLocCode",params)
	if (saveret=="0"){
		$.messager.alert($g("��ʾ"),$g("����ɹ�!"),"info");
		$('#phcodewin').window('close');
		$('#phlocgrid').datagrid('reload');
	}else if (saveret==""){
		$.messager.alert($g("��ʾ"),$g("��ǰ�û��Ǳ�ҩ���û�,������ҩ����Աά�������,�ٽ�����ز���!"),"info");
	}else if (saveret==1){
		$.messager.alert($g("��ʾ"),$g("�÷�ҩ�����Ѵ��ڣ��������ظ����!"),"warning");
	}else{
		$.messager.alert($g("������ʾ"),$g("����ʧ��,�������:")+saveret,"warning");
	}
}
//�޸ķ�ҩ���
function btnUpdateHandler(){
	var phalocselect = $("#phlocgrid").datagrid("getSelected");
	if (phalocselect==null){
		$.messager.alert($g("��ʾ"),$g("����ѡ�����޸ĵ���!"),"info");
		return;
	}
	$('#phcodewin').window({'title':$g("���﷢ҩ����ά���޸�")});
	$('#phcodewin').window('open');
	$("input[type=checkbox][name=chkcondition]").prop('checked',false);
	$("input[name=txtconditon]").val("");	
	if (phalocselect["Tpy"]==$g("��")){
		$('#chkPY').prop('checked',true);
	}
	if (phalocselect["Tfy"]==$g("��")){
		$('#chkFY').prop('checked',true);
	}
	if (phalocselect["Tbyfs"]==$g("��")){
		$('#chkTQ').prop('checked',true);
	}
	if (phalocselect["TCyFlag"]==$g("��")){
		$('#chkZCY').prop('checked',true);
	}
	if (phalocselect["TSendFlag"]==$g("��")){
		$('#chkSend').prop('checked',true);
	}
	if (phalocselect["TPrintFlag"]==$g("��")){
		$('#chkPrint').prop('checked',true);
	}
	if (phalocselect["TWinTypeFlag"]==$g("��")){
		$('#chkWinType').prop('checked',true);
	}
	if (phalocselect["TDispMachine"]==$g("��")){
		$('#chkMachine').prop('checked',true);
	}
	if (phalocselect["TScreenFlag"]==$g("��")){
		$('#chkScreen').prop('checked',true);
	}
	if (phalocselect["Tpysure"]==$g("��")){
		$('#chkSure').prop('checked',true);
	}
	if (phalocselect["TAutoPyFlag"]==$g("��")){
		$('#chkAutoPY').prop('checked',true);
	}
	if (phalocselect["TAuditFlag"]==$g("��")){
		$('#chkAudit').prop('checked',true);
	}
	if (phalocselect["TOthLocRet"]==$g("��")){
		$('#chkOtherLocRet').prop('checked',true);
	}
	$("#screenPath").val(phalocselect["TScreenPath"]);
	$("#phaLoc").combobox("setValue",phalocselect["Tyfid"]);
	$("#phaLoc").combobox("setText",phalocselect["Tdesc"]);
	var dispmath=phalocselect["Tyfsf"];
	$("#dispMath").combobox("setText",phalocselect["Tyfsf"]);
	if (dispmath==$g("���մ���")){
		$("#dispMath").combobox("setValue",1);
	}else if(dispmath==$g("���չ�����")){
		$("#dispMath").combobox("setValue",2);
	}
	$("#phaLoc").combobox('disable')
}

function InitHospCombo(){
	var genHospObj = DHCSTEASYUI.GenHospComp({tableName:'PHA-OP-LocConfig'}); //����ҽԺ
 	if (typeof genHospObj === 'object') {	
	 	//����ѡ���¼�
		$('#_HospList').combogrid("options").onSelect=function(index,record){
			NewHospId=record.HOSPRowId;
			if(NewHospId!=HospId){
				HospId=NewHospId;
				$('#phlocgrid').datagrid('options').queryParams.HospId =  HospId;
				$('#phlocgrid').datagrid('load');		
				$('#phaLoc').combobox('loadData', {})
				$('#phaLoc').combobox('options').url=commonOutPhaUrl+'?action=GetUserAllLocDs&gUserId='+gUserId+'&HospId='+HospId;
				$('#phaLoc').combobox('reload');
			}
		};
 	}
}