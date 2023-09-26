//===========================================================================================
// ���ߣ�      bianshuai
// ��д����:   2018-11-24
// ����:	   ���ﴲ�Խ���
//===========================================================================================

var BsID = "";      /// ����ID
var EmType = "";    /// ��������
var Pid = "";       /// ����ID
var LgUserID = session['LOGON.USERID'];  /// �û�ID
var LgLocID = session['LOGON.CTLOCID'];  /// ����ID
var LgHospID = session['LOGON.HOSPID'];  /// ҽԺID
var ItemGrpArr = [{"value":"���","text":'���'}, {"value":"�а�","text":'�а�'}, {"value":"ҹ��","text":'ҹ��'}];;
var ItemTypeArr = [{"value":"���","text":'���'}, {"value":"�а�","text":'�а�'}, {"value":"ҹ��","text":'ҹ��'}];;
var EpisodeID=""
/// ҳ���ʼ������
function initPageDefault(){
	
	/// ��ʼ�����ز����б�
	InitPatList();
	
	/// ��ʼ�����˻�����Ϣ
	InitPatInfoPanel();

}

/// ��ʼ�����˻�����Ϣ
function InitPatInfoPanel(){
	
	/// ��ʼ����
	$HUI.datebox("#WrDate").setValue(GetCurSystemDate(0));
	
	/// ������Ա
	$("#CarePrv").val(session['LOGON.USERNAME']);
	
	/// ҽ������
	var uniturl = $URL+"?ClassName=web.DHCEMPatCheckLevCom&MethodName=jsonCTMedUnit&LocID="+ session['LOGON.CTLOCID'];
	$HUI.combobox("#MedGrp",{
		url:uniturl,
		data : ItemGrpArr,
		valueField:'value',
		textField:'text',
		onSelect:function(option){
	    }	
	})
	
	/// ��������
	EmType = getParam("EmType");
	if (EmType == "Nur"){
		$HUI.combobox("#MedGrp").disable();
	}
	
	/// ���
	$HUI.combobox("#Schedule",{
		url:'',
		data : ItemTypeArr,
		valueField:'value',
		textField:'text',
		onSelect:function(option){
	    }	
	})
	
	/// ����
	//var uniturl = $URL+"?ClassName=web.DHCEMPatCheckLevQuery&MethodName=jsonWard&HospID="+LgHospID;
	var uniturl = $URL+"?ClassName=web.DHCEMPatCheckLevQuery&MethodName=jsonWard&HospID="+LgHospID;
	$HUI.combobox("#Ward",{
		url:uniturl,
		valueField:'value',
		textField:'text',
		onSelect:function(option){
	    }	
	})
	
}

/// ���˾�����Ϣ
function GetPatBaseInfo(EpisodeID){
	runClassMethod("web.DHCEMConsultQuery","GetPatEssInfo",{"PatientID":"", "EpisodeID":EpisodeID},function(jsonString){
		var jsonObject = jsonString;
		$('.ui-span-m').each(function(){
			$(this).text(jsonObject[this.id]);
			if (jsonObject.PatSex == "��"){
				$("#PatPhoto").attr("src","../scripts/dhcnewpro/images/boy.png");
			}else if (jsonObject.PatSex == "Ů"){
				$("#PatPhoto").attr("src","../scripts/dhcnewpro/images/girl.png");
			}else{
				$("#PatPhoto").attr("src","../images/unman.png");
			}
		})
	},'json',false)
}

/// ҳ��DataGrid��ʼ������ѡ�б�
function InitPatList(){
	
	///  ����columns
	var columns=[[
		{field:'BsItmID',title:'BsItmID',width:100,hidden:true},
		{field:'Edit',title:'�༭',width:100,align:'center',formatter:
			function (value, row, index){
				if (row.BsItmID == ""){
					return "";
				}else{
					return '<a href="#" onclick="WriBedShiftWin('+ index +')">�༭</a>';
				}
			}
		},
		{field:'PatBed',title:'����',width:60,align:'center'},
		{field:'PatName',title:'����',width:100},
		{field:'PatNo',title:'�ǼǺ�',width:100},
		{field:'PatAge',title:'����',width:60,align:'center'},
		{field:'PatSex',title:'�Ա�',width:50,align:'center'},
		{field:'PAAdmDate',title:'��������',width:100,align:'center'},
		{field:'PAAdmTime',title:'����ʱ��',width:100,align:'center'},
		//{field: 'CurrAmt',title: '���',hidden:true,width:75,align:'center',
		// 	 styler: function(value,row,index){
		// 	   	 if(row.CurrAmt<500){
	 	//		    return 'background-color:red;color:white';
		// 	   	 }
	 	//    }
		// },
		{field:'PatDiag',title:'���',width:320},
		//{field:'BsVitalSign',title:'��������',width:320},
		{field:'BsContents',title:'��������',width:320},
		//{field:'WaitToHos',title:'����Ժ����',width:300},
		//{field:'BsMedHis',title:'��ʷ',width:320},
		{field:'BsTreatMet',title:'���Ʒ�ʽ',width:320},
		//{field:'BsCotNumber',title:'��ϵ��ʽ',width:120},
		{field:'BsNotes',title:'��ע',width:320},
		{field:'EpisodeID',title:'EpisodeID',width:100,align:'center'}
	]];
	
	///  ����datagrid
	var option = {
		//showHeader:false,
		toolbar:"#toolbar",
		rownumbers : true,
		singleSelect : true,
		pagination: true,
		nowrap : false,
		onLoadSuccess:function(data){
			if (typeof data.Pid != "undefined"){
				Pid = data.Pid;
			}
		},
        rowStyler:function(rowIndex, rowData){
			if (rowData.AuditFlag == "����"){
				return 'background-color:pink;';
			}
		}
	};
	/// ��������
	var param = "";
	var uniturl = $URL+"?ClassName=web.DHCEMBedSideShift&MethodName=GetEmPatList&Params="+param;
	new ListComponent('bmDetList', columns, uniturl, option).Init(); 
	
}

/// ��ѯ
function QryPatList(){
	
	var MedGrpID = $HUI.combobox("#MedGrp").getValue(); /// ҽ����
	if ((MedGrpID == "")&(EmType == "Doc")){
		$.messager.alert("��ʾ:","��ѡ��ҽ��С�飡","warning");
		return;
	}
	
	var WardID = $HUI.combobox("#Ward").getValue();     /// ������
	if (WardID == ""){
		$.messager.alert("��ʾ:","��ѡ�����۲�����","warning");
		return;
	}
	
	var Schedule=$HUI.combobox("#Schedule").getValue();  /// ������
	if (Schedule == ""){
		$.messager.alert("��ʾ:","�����β���Ϊ�գ�","warning");
		return;
	}
	
	var params = "^" + WardID +"^"+ MedGrpID +"^"+ Pid;
	$("#bmDetList").datagrid("load",{"Params":params}); 
}

/// ��ӡ
function PrintCst(){
	
	var rowsData = $("#bmDetList").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData != null) {
		PrintCst_AUD(rowsData.CstID);
		InsCsMasPrintFlag(rowsData.CstID);  /// �޸Ļ����ӡ��־
	}
}

/// �������ݴ��� bianshuai 2018-11-23
function WriBedShiftWin(index){
	
	var rowData = $('#bmDetList').datagrid('getRows');
	EpisodeID=rowData[index].EpisodeID   //����ID
	PatientID=rowData[index].PatientID;  //����ID
	GetPatBaseInfo(EpisodeID)            //��ȡ���˻�����Ϣ
	var option = {
		modal : true,
		title : "��������",
		collapsible : false,
		minimizable : false,
		maximizable : false,
		width : (window.screen.availWidth-300), 
		height : 580, ///(window.screen.availHeight-230),
		iconCls:'icon-w-paper',
		buttons:[{
			text:'����',
			iconCls:'icon-w-save',
			handler:function(){
				saveBedShift(rowData[index].BsItmID)
				}
		},{
			text:'ȡ��',
			iconCls:'icon-w-close',
			handler:function(){
				$('#BedShiftWin').dialog('close');
			}
		}]
	};
	
	$HUI.dialog('#BedShiftWin', $.extend({},option));
	$('#BedShiftWin').dialog('open');
	InitShiftPanel(rowData[index]);  /// ��ʼ���Ӱ�����Panel
}

/// ��ʼ���Ӱ�����Panel
function InitShiftPanel(row){
	
	$('#BsPatDiag').val(row.PatDiag);        /// �������
	$('#BsVitalSign').val(row.BsVitalSign);  /// ��������
	$('#BsContents').val(row.BsContents);    /// ��������
	$('#BsNotes').val(row.BsNotes);          /// ��ע
	$('#BsMedHis').val(row.BsMedHis);        /// ��ʷ
	$('#BsTreatMet').val(row.BsTreatMet);    /// ���Ʒ�ʽ
	$('#BsCotNumber').val(row.BsCotNumber);  /// ��ϵ��ʽ
	
}

/// ���潻������
function InsBedMas(){

	var MedGrpID = $HUI.combobox("#MedGrp").getValue(); /// ҽ��С��
	if ((MedGrpID == "")&(EmType == "Doc")){
		$.messager.alert("��ʾ:","��ѡ��ҽ��С�飡","warning");
		return;
	}
	var WardID=$HUI.combobox("#Ward").getValue();      /// ���ಡ��
	if (WardID == ""){
		$.messager.alert("��ʾ:","����������Ϊ�գ�","warning");
		return;
	}
	var Schedule=$HUI.combobox("#Schedule").getValue();  /// ������
	if (Schedule == ""){
		$.messager.alert("��ʾ:","��β���Ϊ�գ�","warning");
		return;
	}
	var WrDate=$HUI.datebox("#WrDate").getValue();       /// ��������
	
	var rowData = $('#bmDetList').datagrid('getRows');
	if ((typeof rowData == "undefined")||(rowData == "")){
		//alert(rowData)
		$.messager.alert("��ʾ:","û�д����没����Ϣ��","warning");
		return;
	}
	
	///             ��������  +"^"+  ������  +"^"+  ���  +"^"+  ��������  +"^"+  ������Ա  +"^"+  ҽ������
	var mListData = WrDate +"^"+ WardID +"^"+ Schedule +"^"+ EmType +"^"+ LgUserID +"^"+ MedGrpID;

	/// ����
	runClassMethod("web.DHCEMBedSideShift","Insert",{"BsID":BsID, "mListData":mListData, "Pid":Pid},function(jsonString){
		if (jsonString < 0){
		   if(jsonString == "-1"){
			   $.messager.alert("��ʾ:","�ð�����м�¼���뵽<font style='color:red;font-weight:bold;'>�ѱ����ѯ</font>�����ѯ��","warning");
	       }else{
			   $.messager.alert("��ʾ:","��������Ϣ����ʧ�ܣ�ʧ��ԭ��:"+jsonString,"warning");
		   }
		}else{
			GetEmShift(jsonString);  /// ��ȡ������Ϣ
			$.messager.alert("��ʾ:","����ɹ���","warning");
		}
	},'',false)
}

/// ���潻������
function saveBedShift(BsItmID){

	var BsPatDiag=$('#BsPatDiag').val();  /// �������
//	if (BsPatDiag == ""){
//		$.messager.alert("��ʾ:","������ϲ���Ϊ�գ�");
//		return;
//	}

	var BsVitalSign=$('#BsVitalSign').val();  /// ��������
//	if (BsVitalSign == ""){
//		$.messager.alert("��ʾ:","������������Ϊ�գ�");
//		return;
//	}
	var BsContents=$('#BsContents').val();  /// ��������
	if (BsContents == ""){
		$.messager.alert("��ʾ:","�������ݲ���Ϊ�գ�");
		return;
	}
	
	var BsNotes = $('#BsNotes').val();  /// ��ע
	
	var BsMedHis=$('#BsMedHis').val();  /// ��ʷ����
//	if (BsMedHis == ""){
//		$.messager.alert("��ʾ:","��ʷ����Ϊ�գ�");
//		return;
//	}
	
	var BsTreatMet=$('#BsTreatMet').val();  /// ���Ʒ�ʽ
	if (BsTreatMet == ""){
		$.messager.alert("��ʾ:","���Ʒ�ʽ����Ϊ�գ�");
		return;
	}
	
	var BsCotNumber=$('#BsCotNumber').val();  /// ��ϵ��ʽ
//	if (BsCotNumber == ""){
//		$.messager.alert("��ʾ:","��ϵ��ʽ����Ϊ�գ�");
//		return;
//	}
//		
	
	///             �������  +"^"+  ��������  +"^"+  ��������  +"^"+  ��ע   +"^"+  ��ʷ +"^"+  ���Ʒ�ʽ  +"^"+ ��ϵ��ʽ
	var mListData = BsPatDiag +"^"+ BsVitalSign +"^"+ BsContents +"^"+ BsNotes+"^"+BsMedHis+"^"+BsTreatMet+"^"+BsCotNumber;

	/// ����
	runClassMethod("web.DHCEMBedSideShift","UpdBedItem",{"BsItmID":BsItmID, "mListData":mListData},function(jsonString){
		if (jsonString < 0){
			$.messager.alert("��ʾ:","�������ݱ���ʧ�ܣ�ʧ��ԭ��:"+jsonString,"warning");
		}else{
			$.messager.alert("��ʾ:","����ɹ���","warning");
			$('#BedShiftWin').dialog('close');  /// �رս������ݴ���
			$("#bmDetList").datagrid("reload");
		}
	},'',false)
}

/// ���ؽ�����Ϣ
function GetEmShift(InBsID){
	BsID = InBsID;
	GetEmShiftObj(BsID);  /// ��ʼ�����ؼӰ�����Ϣ
	$("#bmDetList").datagrid("load",{"Params":BsID});
}

/// ��ȡ������Ϣ
function GetEmShiftObj(BsID){
	
	runClassMethod("web.DHCEMBedSideShift","JsGetEmShiftObj",{"BsID":BsID},function(jsonString){

		if (jsonString != ""){
			var jsonObjArr = jsonString;
			InsEmShiftObj(jsonObjArr);
		}
	},'json',false)
}

/// ������������
function OpenSign(){
	var url="dhcem.patemrque.csp?&EpisodeID="+EpisodeID+"&PatientID="+PatientID+"&targetName=Attitude"+"&TextValue="; //+obj.text;
	var result = window.showModalDialog(url,"_blank",'dialogTop:0;dialogWidth:'+(window.screen.availWidth-200)+'px;DialogHeight='+(window.screen.availHeight-200)+'px;dialogTop=100px;center=1'); 
	try{
		if (result){
			if ($("#BsVitalSign").val() == ""){
				$("#BsVitalSign").val(result.innertTexts);  		/// ��������
			}else{
				$("#BsVitalSign").val($("#BsVitalSign").val()  +"\r\n"+ result.innertTexts);  		/// ��������
			}
			
		}
	}catch(ex){}
}

//��������
function OpenTreatMet(){
	var url="dhcem.patemrque.csp?&EpisodeID="+EpisodeID+"&targetName=Attitude"+"&TextValue="; //+obj.text;
	var result = window.showModalDialog(url,"_blank",'dialogTop:0;dialogWidth:'+(window.screen.availWidth-200)+'px;DialogHeight='+(window.screen.availHeight-200)+'px;dialogTop=100px;center=1'); 
	try{
		if (result){
			if ($("#BsTreatMet").val() == ""){
				$("#BsTreatMet").val(result.innertTexts);  		/// ����
			}else{
				$("#BsTreatMet").val($("#BsTreatMet").val()  +"\r\n"+ result.innertTexts);  		/// ����
			}
			
		}
	}catch(ex){}
}

/// ���ý�����Ϣ
function InsEmShiftObj(itemobj){
	
	/// ҽ������
	$HUI.combobox("#MedGrp").setValue(itemobj.MedGrpID);
	$HUI.combobox("#MedGrp").disable();
    /// ���ಡ��
	$HUI.combobox("#Ward").setValue(itemobj.WardID);
	$HUI.combobox("#Ward").disable();
    /// ������
	$HUI.combobox("#Schedule").setValue(itemobj.Schedule);
	$HUI.combobox("#Schedule").disable();
    /// ��������
	$HUI.datebox("#WrDate").setValue(itemobj.WrDate);
	/// ������Ա
	$("#CarePrv").val(itemobj.UserName);
	
	$("#find").linkbutton('disable');  /// ��ѯ��ť
	$("#save").linkbutton('disable');  /// ���水ť
}

/// ���ҳ��Ԫ������
function ClrPagesEl(){
	
	BsID = "";      /// ����ID
	/// ҽ������
	$HUI.combobox("#MedGrp").setValue("");
	$HUI.combobox("#MedGrp").enable();
    /// ���ಡ��
	$HUI.combobox("#Ward").setValue("");
	$HUI.combobox("#Ward").enable();
    /// ������
	$HUI.combobox("#Schedule").setValue("");
	$HUI.combobox("#Schedule").enable();
    /// ��������
	$HUI.datebox("#WrDate").setValue(GetCurSystemDate(0));
	/// ������Ա
	$("#CarePrv").val(session['LOGON.USERNAME']);
	$("#bmDetList").datagrid("loadData", { total: 0, rows: [] });
	
	$("#find").linkbutton('enable');  /// ��ѯ��ť
	$("#save").linkbutton('enable');  /// ���水ť
}

/// ��ȡϵͳ��ǰ����
function GetCurSystemDate(offset){
	
	var SysDate = "";
	runClassMethod("web.DHCEMConsultCom","GetCurSystemDate",{"offset":offset},function(jsonString){

		if (jsonString != ""){
			SysDate = jsonString;
		}
	},'',false)
	return SysDate
}

/// ɾ�������¼
function DelShifts(){

	if (BsID == ""){
		$.messager.alert("��ʾ:","����ѡ��һ�ν����¼�����ԣ�");
		return;
	}
	$.messager.confirm('ȷ�϶Ի���','ȷ��Ҫɾ����ǰ�����¼��', function(r){
		if (r){
			runClassMethod("web.DHCEMBedSideShift","DelBedSideShift",{"BsID":BsID},function(jsonString){

				if (jsonString < 0){
					$.messager.alert("��ʾ:","ɾ�������¼ʧ�ܣ�ʧ��ԭ��:"+jsonString,"warning");
				}else{
					$.messager.alert("��ʾ:","ɾ���ɹ���");
					ClrPagesEl(); /// ��ս�������
				}
			},'',false)
		}
	});
}

/// �����б���
function ShowBedLisWin(){
	
	var option = {
		collapsible:false,
		minimizable:false,
		maximizable:false,
		border:true,
		closed:"true",
		iconCls:'icon-w-paper'
	};
	new WindowUX('�����б���', 'BedLisWin', (window.screen.availWidth-100), (window.screen.availHeight-150), option).Init();
	$("#LisFrame").attr("src","dhcem.bedsideshiftquery.csp?EmType="+EmType);
}

/// �رս����б���
function CloseBedListWin(){
	
	$("#BedLisWin").window('close');
}
	
/// ɾ����ʱglobal
function killTmpGlobal(){

	runClassMethod("web.DHCEMBedSideShift","killTmpGlobal",{"Pid":Pid},function(jsonString){
	},'',false)
}

/// ҳ��ر�֮ǰ����
function onbeforeunload_handler() {
    killTmpGlobal();  /// �����ʱglobal
}

window.onbeforeunload = onbeforeunload_handler;

/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })
