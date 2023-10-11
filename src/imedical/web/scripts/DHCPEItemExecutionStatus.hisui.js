
//����    DHCPEItemExecutionStatus.hisui.js
//����    ����Ѽ�δ��������Ŀ��ѯ
//����  
//������  zhongricheng
$(function() {
	InitCombobox();
	
	$("#BFind").click(function() {  // ������ѯ
		BFind_click();
    });
    
    $("#BClear").click(function() {  // ������ѯ
		BClear_click();
    });
	
	ShowRunQianUrl("ReportFile", "dhccpmrunqianreport.csp?reportName=DHCPEItemExecutionStatus.raq");
});

function InitCombobox() {
	// �Ա�
	$HUI.combobox("#Sex", {
		valueField:'id',
		textField:'text',
		panelHeight:"auto",
		editable:false,
		data:[
			{id:'',text:$g('����')},
			{id:'1',text:$g('��')},
			{id:'2',text:$g('Ů')}
		]
	});
	
	/*
	// վ��
	$HUI.combobox("#Station", {
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindStationByType&Type=NLX&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		//editable:false,
		onSelect:function(record) {
			var StationId = record.id;
			var url = $URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindStationOrder&ResultSetType=array&Station=" + StationId;
			$("#ItemID").combobox('reload',url);
		},
		onChange:function(newValue, oldValue) {
			var ItemID = $("#ItemID").combobox('getValue');
			var Flag=tkMakeServerCall("web.DHCPE.HISUICommon","GetStationFlag",newValue,ItemID);
			if (Flag==0) {
			    $("#ItemID").combobox('setValue',"");
			}
			if (newValue == "" || newValue == "undefined" || newValue == undefined) {
				var url = $URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindStationOrder&ResultSetType=array&Station=";
				$("#ItemID").combobox('reload',url);				
			}
		}
	});
	*/
	 // վ��-��Ժ��
	$HUI.combobox("#Station", {
		url:$URL+"?ClassName=web.DHCPE.CT.HISUICommon&QueryName=FindStationByType&ResultSetType=array&Type=NLX&LocID="+session['LOGON.CTLOCID'],
		valueField:'id',
		textField:'desc',
		onBeforeLoad:function(param){
			param.Desc = param.q;
		},
		onSelect:function(record) {
			 
			 /***�л�վ�������Ŀ���¼���***/
			 $("#ItemID").combogrid('setValue',"");
			
			 $HUI.combogrid("#ItemID",{
                onBeforeLoad:function(param){
                   	param.Desc = param.q;
                   	var StationId = record.id;
					param.Station = StationId;
					param.Type="F";
					param.LocID=session['LOGON.CTLOCID'];
					param.hospId = session['LOGON.HOSPID'];

                }
            });
			$('#ItemID').combogrid('grid').datagrid('reload'); 
			 /***�л�վ�������Ŀ���¼���***/
			 
        
		},
		onChange:function(newValue, oldValue) {
			var ItemID = $("#ItemID").combogrid('getValue');
			var Flag=tkMakeServerCall("web.DHCPE.CT.HISUICommon","GetStationFlag",newValue,ItemID,session['LOGON.CTLOCID']);
			if (Flag==0) {
			    $("#ItemID").combogrid('setValue',"");    
			}
		
			
		}
	});
		

	// �ܼ�״̬
	$HUI.combobox("#AuditStatus", {
		valueField:'id',
		textField:'text',
		panelHeight:"auto",
		editable:false,
		data:[
			{id:'',text:$g('����')},
			{id:'NA',text:$g('δ�ܼ�')},
			{id:'A',text:$g('���ܼ�')}
		]
	});
	
	/*
	// ��Ŀ
	$HUI.combobox("#ItemID", {
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindStationOrder&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		//editable:false,
		defaultFilter:4,
		onBeforeLoad:function(param){
			param.Desc = param.q;
			param.Type="F";
			param.LocID=session['LOGON.CTLOCID'];
			param.hospId = session['LOGON.HOSPID'];
		}

	});
	*/
	/*
	//��Ŀ-��Ժ��
	$HUI.combobox("#ItemID", {
		url:$URL+"?ClassName=web.DHCPE.CT.HISUICommon&QueryName=FindStationOrder&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		//editable:false,
		defaultFilter:4,
		onBeforeLoad:function(param){
			param.Desc = param.q;
			param.Type="F";
			param.LocID=session['LOGON.CTLOCID'];
			param.hospId = session['LOGON.HOSPID'];
		}

	});
	*/
//�����Ŀ-��Ժ��
	var ItemObj=$HUI.combogrid("#ItemID", {
		panelWidth:450,
		panelHeight:245,
		url:$URL+"?ClassName=web.DHCPE.CT.HISUICommon&QueryName=FindStationOrder",
		idField:'id',
		textField:'desc',
		mode:'remote',
		delay:200,
		pagination:true,
		minQueryLen:1,
        rownumbers:true,//���   
		fit: true,
		pageSize: 5,
		pageList: [5,10],
		onBeforeLoad:function(param){
			param.Desc = param.q;
			var StationId=$("#Station").combobox("getValue");
			param.Station = StationId;
			param.Type="F";
			param.LocID=session['LOGON.CTLOCID'];
			param.hospId = session['LOGON.HOSPID'];
		},
        onShowPanel:function()
		{
			$('#ItemID').combogrid('grid').datagrid('reload');
		},		
		columns:[[
			{field:'Code',title:'����',width:80},
			{field:'desc',title:'����',width:180},
			{field:'id',title:'ID',width:80}         		
		]]

	});
	/*
	// VIP�ȼ�
	$HUI.combobox("#VIPLevel", {
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindVIP&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		//editable:false,
		onSelect:function(record){
		}
	});

	// ����λ��
	$HUI.combobox("#PERoom", {
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindRoomPlace&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		//editable:false,
		onSelect:function(record){
		}
	});
	*/
	
	//VIP�ȼ�-��Ժ�� 
	var VIPObj = $HUI.combobox("#VIPLevel",{
		url:$URL+"?ClassName=web.DHCPE.CT.HISUICommon&QueryName=FindVIP&ResultSetType=array&LocID="+session['LOGON.CTLOCID'],
		valueField:'id',
		textField:'desc',
		 onSelect:function(record){
			VIPLevelOnChange(record.id);
		}
	});

   // ����λ��(��Ժ��)
	$HUI.combobox("#PERoom", {
		url:$URL+"?ClassName=web.DHCPE.CT.HISUICommon&QueryName=FindRoomPlace&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		onBeforeLoad:function(param){
			var VIPID=$("#VIPLevel").combobox("getValue");
			param.VIPLevel =VIPID;
			param.GIType="";
			param.LocID=session['LOGON.CTLOCID'];

		}
	});


	
	// ���״̬
	$HUI.combobox("#ChcekStatus", {
		valueField:'id',
		textField:'text',
		panelHeight:"auto",
		editable:false,
		data:[
			{id:'',text:$g('����')},
			{id:'NC',text:$g('ȫ��δ��')},
			{id:'PC',text:$g('�����Ѽ�')},
			{id:'AC',text:$g('ȫ���Ѽ�')}//,
			//{id:'RC',text:$g('л�����')}
		]
	});
	
	// ��Ŀ״̬
	$HUI.combobox("#ItemStatus", {
		valueField:'id',
		textField:'text',
		panelHeight:"auto",
		editable:false,
		data:[
			{id:'',text:$g('����')},
			{id:'V',text:$g('��ʵ')},
			{id:'E',text:$g('ִ��')},
			{id:'R',text:$g('л�����')}
		]
	});
	
	// ��ѯ����
	$HUI.combobox("#ShowType", {
		valueField:'id',
		textField:'text',
		panelHeight:"auto",
		editable:false,
		data:[
			{id:'PAADM',text:$g('����Ա��ѯ'),selected:true},
			{id:'ITEM',text:$g('����Ŀ��ѯ')}
		]
	});
	
	//����
	var GroupNameObj = $HUI.combogrid("#GroupName",{
		panelWidth:450,
		panelHeight:260,
		url:$URL+"?ClassName=web.DHCPE.DHCPEGAdm&QueryName=GADMList",
		mode:'remote',
		delay:200,
		pagination:true,
		minQueryLen:1,
        rownumbers:true,//���   
		fit: true,
		pageSize: 5,
		pageList: [5,10],
		idField:'TRowId',
		textField:'TGDesc',
		onBeforeLoad:function(param){
			param.GBIDesc = param.q;
		},
		columns:[[
			{field:'TRowId',title:'����ID',width:80},
			{field:'TGDesc',title:'��������',width:140},
			{field:'TGStatus',title:'״̬',width:100},
			{field:'TAdmDate',title:'����',width:100}		
		]]
	})
}

function VIPLevelOnChange(){
	
	 var CTLocID=session['LOGON.CTLOCID'];
    
    /***********�������¼���********************/
	  $HUI.combobox("#PERoom",{
		onBeforeLoad:function(param){
            var VIPID=$("#VIPLevel").combobox("getValue");
            param.VIPLevel = VIPID;
            param.GIType = "";
            param.LocID = CTLocID;
        }
	});
		        
    $('#RoomPlace').combobox('reload'); 
    /***********�������¼���********************/
}


// ��ѯ
function BFind_click(){
	var BeginDate = "", EndDate = "", Sex = "", VIPLevel = "", Station = "", PERoom = "", AuditStatus = "", ChcekStatus = "", ItemID = "", ItemStatus = "", CurLoc = "", reportName="";
	var BeginDate = $("#BeginDate").datebox('getValue');	
	var EndDate = $("#EndDate").datebox('getValue');
	
	var Sex = $("#Sex").combobox('getValue');
	
	var VIPLevel = $("#VIPLevel").combobox('getValue');
	if (VIPLevel == "undefined" || VIPLevel == undefined) VIPLevel = "";
	
	var Station = $("#Station").combobox('getValue');
	if (Station == "undefined" || Station == undefined) Station = "";
	
	var PERoom = $("#PERoom").combobox('getValue');
	if (PERoom == "undefined" || PERoom == undefined) PERoom = "";
	
	var AuditStatus = $("#AuditStatus").combobox('getValue');
	var ChcekStatus = $("#ChcekStatus").combobox('getValue');
	
	//var ItemID = $("#ItemID").combobox('getValue');
	var ItemID = $("#ItemID").combogrid('getValue');
	if (ItemID == "undefined" || ItemID == undefined) ItemID = "";
	
	var GroupDR=$("#GroupName").combogrid("getValue");
	if (GroupDR == undefined || GroupDR == "undefined") { var GroupDR = ""; }
	
	var ItemStatus = $("#ItemStatus").combobox('getValue');
	var ShowType = $("#ShowType").combobox('getValue');
		
	if (ShowType == "PAADM") {
		reportName="DHCPEItemExecutionStatus.raq"
	} else if (ShowType == "ITEM") {
		reportName="DHCPEItemExecutionStatusForItem.raq"		
	}
	
	var CurLoc = session["LOGON.CTLOCID"];
	
	var src = "&BeginDate=" + BeginDate
			+ "&EndDate=" + EndDate
			+ "&Sex=" + Sex
			+ "&VIPLevel=" + VIPLevel
			+ "&Station=" + Station
			+ "&PERoom=" + PERoom
			+ "&AuditStatus=" + AuditStatus
			+ "&ChcekStatus=" + ChcekStatus
			+ "&ItemID=" + ItemID
			+ "&ItemStatus=" + ItemStatus
			+ "&ShowType=" + ShowType
			+ "&GroupDR=" + GroupDR
			+ "&CurLoc=" + CurLoc
			;
	
	ShowRunQianUrl("ReportFile", "dhccpmrunqianreport.csp?reportName=" + reportName + src);
	//$("#ReportFile").attr("src", "dhccpmrunqianreport.csp?reportName=DHCPEItemExecutionStatusForItem.raq" + src);
}

function BClear_click(){
	$("#BeginDate").datebox('setValue',"");
	$("#EndDate").datebox('setValue',"");
	$(".hisui-combobox").combobox('setValue',"");
	$("#GroupName").combogrid('setValue',"");
    $("#ItemID").combogrid('setValue',"");
	$("#ShowType").combobox('setValue',"PAADM");
	InitCombobox();
	BFind_click();
}
// ���iframe�� ��Ǭcsp ��������
function ShowRunQianUrl(iframeId, url) {
    var iframeObj = document.getElementById(iframeId)
    if (iframeObj) {
	    iframeObj.src=url;
	    //debugger;
	    $(iframeObj).hide();
	    if (iframeObj.attachEvent) {
		    iframeObj.attachEvent("onload", function(){
		        $(this).show();
		    });
	    } else {
		    iframeObj.onload = function(){
		        $(this).show();
		    };
	    }
    }
}