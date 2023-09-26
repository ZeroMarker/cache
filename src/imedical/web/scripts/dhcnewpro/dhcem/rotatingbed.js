//===========================================================================================
// ���ߣ�      sufan
// ��д����:   2018-07-31
// ����:	   ����ת��
//===========================================================================================
var EpisodeID="";
var WardId="";
var CurrState="";
var PatAllStatus="";   //����״̬
var PAAdmWard="";    //���ߵ�ǰ���ڲ���
/// ҳ���ʼ������
function initPageDefault(){
    LoadEpisodeID();          /// ��ʼ�������
    CheckPatStatus();
	InitPageComponent(); 	  /// ��ʼ������ؼ�����
	initCombogrid();
	GetPatBaseInfo();         /// ���˾�����Ϣ
    InitPatBaseBar();         /// ���˾�����Ϣ
	InitPageDataGrid();		  /// ��ʼ��ҳ��datagrid
}
function LoadEpisodeID(){
	EpisodeID = getParam("EpisodeID");
	
}

///��֤�����Ƿ��ܽ���ת��
function CheckPatStatus(){
	if(PatIsDea()==1){
		$.messager.alert("��ʾ","�����ѹʣ�������ת�Ʋ�����","info",function(){
			websys_showModal("close");
		});
	}
}

///�жϻ����Ƿ��Ѿ�����
function PatIsDea(){
	var retData=0;
	runClassMethod("web.DHCEMNurExecImg","GetPatIsDeath",{"EpisodeID":EpisodeID},function(ret){
		retData=ret
	},'text',false)
	return parseInt(retData); 
}

/// ��ʼ������ؼ�����
function InitPageComponent(){
	
	$("#disPatWin-disStDate").datebox("setValue",formatDate(0));
	$('#disPatWin-disStTime').timespinner('setValue',curTime());
	///���ﲡ��
	$HUI.combobox("#EmWard",{
		url:LINK_CSP+"?ClassName=web.DHCEMPatCheckLevQuery&MethodName=jsonWard&HospID="+LgHospID,
		valueField:'value',
		textField:'text',
		onSelect:function(option){
	      	var WardId=option.value;
	      	$('#EmBed').combogrid('setValue',"");
	      	$("#EmBed").combogrid('grid').datagrid('load',{WardId:WardId,HospID:LgHospID})
	      	var ret = tkMakeServerCall("web.DHCADMVisitStat", "GetStayStatus", EpisodeID)
			if(ret==-1){
				 $.messager.alert("��ʾ","�ò���Ϊ��Һ����,����ת�ƣ�");
			     return false;
			 }
	      	
	    }	
	})
	
	///���˵�ǰ״̬
	runClassMethod("web.DHCADMVisitStat","GetPatCurStat",{"EpisodeID":EpisodeID},function(jsonString){
		var stat=jsonString.split("^")
		CurrState=stat[1];
		if(stat[1]=="��Ժ"){
			
		}
	},'',false)
	
	///��������״̬
	runClassMethod("web.DHCEMRotatBed","getPatAllStatus",{"EpisodeID":EpisodeID},function(data){
		PatAllStatus=data;
	},'',false)
	
	///���˵�ǰ���ڲ���
	runClassMethod("web.DHCEMRotatBed","getPatCurWard",{"EpisodeID":EpisodeID},function(data){
		PAAdmWard=data;
	},'',false)
	
	///����ȼ�
	runClassMethod("web.DHCEMInComUseMethod","GetEmPatLev",{"EpisodeID":EpisodeID},function(ret){
		$("#EmLevel").val(setCellLabel(ret)); //hxy 2020-02-20
	},'text',false)

}

function initCombogrid()
{
	
	var url = LINK_CSP+'?ClassName=web.DHCEMRotatBed&MethodName=jsonEmPatBed&WardId='+WardId+"&HospID="+LgHospID;
	
	///  ����columns
	var columns=[[
		{field:'BedId',title:'BedId',width:100,hidden:true},
		{field:'WardId',title:'WardId',width:100,hidden:true},
		{field:'BedCode',title:'����',width:80},
		{field:'BedFlag',title:'״̬',width:60,hidden:true,formatter:
			function (value, row, index){
				if (value == "Y"){return '<font style="color:red;font-weight:bold;">����</font>'}
				else {return '<font style="color:green;font-weight:bold;"></font>'}
			}
		},
		{field:'WardDesc',title:'����',width:150},
		{field:'RoomCode',title:'����',width:100},
		{field:'BedType',title:'��λ����',width:80},
		{field:'RoomType',title:'��������',width:100,hidden:true}
	]];
	
	$('#EmBed').combogrid({
			url:url,
			editable:false,
			panelHeight:260,   
		    panelWidth:500,
		    idField:'BedId',
		    textField:'BedCode',
		    columns:columns,
		    pagination:true,
		   	pageSize:50,
		    pageList:[50,100,150],
	        onSelect: function (rowIndex, rowData) {
		        if (rowData.BedFlag == "Y"){
			        $.messager.alert("��ʾ","�ô�λ���в��ˣ���ѡ��������λ��");
		    		$('#EmBed').combogrid('setValue',"");
		        }
        	}
	});
}
///����ת��35000212---------------------------
function Update()
{
	var BedId=$('#EmBed').combogrid('getValue');    //����
	var WardId=$HUI.combobox("#EmWard").getValue();    //����ID
	if(BedId=="")
	{
		$.messager.alert("��ʾ","��ѡ��λ��");
		return false;
	}
	
	///������Ժ���ߣ����ܽ���ת�� 2018-10-17  sufan
	if((CurrState=="��Ժ")||(CurrState=="��Ժ")||(CurrState=="תԺ")||(CurrState=="����"))    
	{
		$.messager.alert("��ʾ","��Ժ����Ժ������״̬�Ļ��ߣ����ܽ��д˲�����")
		return false;
	}
	
	if(WardId=="")
	{
		$.messager.alert("��ʾ","��ѡ���ﲡ����");
		return false;
	}
	
	var WardDesc=$HUI.combobox("#EmWard").getText();    //����
	var QuitFlag = serverCall("web.DHCEMVisitStat", "JudgePatCurRecord", { 'EpisodeID':EpisodeID});
	if(QuitFlag=="Y")
	{
		$.messager.alert("��ʾ","�������ڼ��ﲡ����λ�������ٴ���۲��һ�໤�ң�");
		return false;
	}
	//var param =LgUserID+"^"+BedId+"^"+WardId+"^"+EpisodeID+"^"+stDate+"^"+stTime+"^"+""+"^"+"";
	if((PAAdmWard=="")||((PAAdmWard!="")&&(PAAdmWard!=WardDesc)))
	{
		if(WardDesc=="����۲���")
		{
			var StatCode="InObservationRoom";
			changestatus(BedId,WardId,WardDesc,StatCode);    ///�ı仼��״̬�����Ŵ�λ
			insertGroupReceipt();//
		}else if(WardDesc=="����໤��")
			{
				var StatCode="InMonitoringRoom";
				changestatus(BedId,WardId,WardDesc,StatCode);    ///�ı仼��״̬�����Ŵ�λ
				insertGroupReceipt();//
			}
		if(WardDesc=="���������(����)")
		{
			changepatBed(BedId,WardId);      ///���䴲λ
		}
		
		///���벡����
		//insertGroupReceipt();
	}
	if((PAAdmWard!="")&&(PAAdmWard==WardDesc))
	{
		 changepatBed(BedId,WardId);      ///���䴲λ
	}
}
///�ı�״̬�����Ŵ�λ
function changestatus(BedId,WardId,WardDesc,StatCode)
{
	var stDate = GetCurSysDate(0);
	var stTime = getCurTime();
	runClassMethod("web.DHCADMVisitStat","InsertVis",
		{"EpisodeID":EpisodeID,"visStatCode":StatCode,"avsDateStr":stDate,
		"avsTimeStr":stTime,"userId":LgUserID,"wardDesc":WardDesc,"cancelFlag":0},
		function(retStr){
			if (retStr != ""){
				if (retStr != 0) {
					alert(retStr); //alert("���벡��״̬����!");
					return;
				}else {
						runClassMethod("web.DHCEMObsRoomSeat","MoveAdm",{"EpisodeID":EpisodeID,"UserID":LgUserID,"WardID":WardId,"BedID":BedId,"EditPreTrans":"Y"},
						function(data){
							if (data==="0") {
								$.messager.alert("��ʾ","���ųɹ���","",function()
								{
									window.close();
								});		
							}else{
									$.messager.alert("��ʾ",data+"��");
									return;
								}
						},'text',false)
				}

			}
		},'',false)
}
///ֻ�л���λ
function changepatBed(BedId,WardId)
{
	runClassMethod("web.DHCADTTransaction","MoveAdm",{"EpisodeID":EpisodeID,"userId":LgUserID,"wardDescOrId":WardId,"bedId":BedId,"editPreTrans":"Y"},
		function(data){
			if (data==="0") {
				$.messager.alert("��ʾ","���ųɹ���","",function()
				{
					window.close();
				});
			}else{
					$.messager.alert("��ʾ",data+"��");
					return;
				}
		},'text',false)
}
/// ��ȡϵͳ����
function GetCurSysDate(offset){

	var SysDate = "";
	runClassMethod("web.DHCEMConsultCom","GetCurSystemDate",{"offset":offset},function(jsonString){

		if (jsonString != ""){
			SysDate = jsonString;
		}
	},'',false)
	return SysDate;
}
///��ȡ��ǰʱ��
function getCurTime()
{
	///ʱ��
	var myDate = new Date();
	//var mytime=myDate.toLocaleTimeString(); //��ȡ��ǰʱ��
	var hh=myDate.getHours();
	if(hh<10){  hh = "0"+hh;}
	var mm=myDate.getMinutes()
	if(mm<10){  mm = "0"+mm;}
	var ss=myDate.getSeconds();
	if(ss<10){  ss = "0"+ss;} 
	return hh+":"+mm+":"+ss
	
}

///���ɲ����Žӿ�
function insertGroupReceipt()
{
	runClassMethod("DHCWMR.SSService.ReceiptSrv","GroupReceipt",{"aEpisodeID":EpisodeID,"aMrNo":"","aLocID":LgCtLocID,"aUserID":LgUserID,"aNoTypeID":"101||1"},
	function(jsonString){

		if (jsonString != ""){
			//alert(jsonString)
		}
	},'',false)
	
}

/// ���˾�����Ϣ  bianshuai 2019-01-24
function GetPatBaseInfo(){
	
	runClassMethod("web.DHCEMRotatBed","GetPatEssInfo",{"PatientID":"", "EpisodeID":EpisodeID},function(jsonString){
		
		var jsonObject = jsonString;
		$('input[name="PatInfo"]').each(function(){
			$(this).val(jsonObject[this.id]).attr("disabled","disabled");
		})
		
	},'json',false)
}

/// ת�Ʋ���  bianshuai 2019-01-24
function TransPatWardBed(BedId,WardId){

  var ret = tkMakeServerCall("web.DHCADMVisitStat", "GetStayStatus", EpisodeID)
   if(ret==-1){
	   $.messager.alert("��ʾ","�ò���Ϊ��Һ����,����ת�ƣ�");
		return false;
	  
    }
	runClassMethod("web.DHCADTTransaction","MoveAdm",{"EpisodeID":EpisodeID,"userId":LgUserID,"wardDescOrId":WardId,"bedId":BedId,"editPreTrans":"Y"},
		function(data){
			if (data==="0") {
				if (window.opener){
					//window.opener.postMessage("ˢ�¼��ﴲλͼ","http://172.21.235.1");
					window.opener.postMessage("ˢ�¼��ﴲλͼ","http://"+window.location.host);
				}
				$.messager.alert("��ʾ","���ųɹ���","",function(){
					window.parent.top.frames[0].location.reload();
					window.parent.top.websys_showModal("close");
				});
			}else{
					$.messager.alert("��ʾ",data+"��");
					return;
				}
		},'text',false)
}

/// ����ת��  bianshuai 2019-01-24
function TrsWardBed(){
	
	var WardId=$HUI.combobox("#EmWard").getValue();    //����ID
	if (typeof WardId == "undefined") WardId = "";
	if(WardId==""){
		$.messager.alert("��ʾ","��ѡ���ﲡ����");
		return false;
	}
	
	/// ��λΪ��ת�Ƶ���Ӧ�����ĵȺ��� bianshuai 2019-01-25
	var BedId=$('#EmBed').combogrid('getValue');    //����
//	if(BedId==""){
//		$.messager.alert("��ʾ","��ѡ��λ��");
//		return false;
//	}

	/// ������Ժ���ߣ����ܽ���ת�� 2018-10-17  sufan
	if((CurrState=="��Ժ")||(CurrState=="��Ժ")||(CurrState=="תԺ")||(CurrState=="����")){
		$.messager.alert("��ʾ","��������Ժ�����ܽ��д˲�����")
		return false;
	}

	/// ת�Ʋ�����λʱ���Ƿ������ⲡ������״̬�����������
	if((BedId||"") == ""){
		$.messager.confirm('ȷ�϶Ի���','��δѡ��λ���Ƿ񽫲���ת�����Ⱥ�����', function(r){
			if (r){
				TransPatWardBed(BedId,WardId);      /// ���䴲λ
			}
		});
	}else{
		TransPatWardBed(BedId,WardId);      /// ���䴲λ
	}
}


/// ���˾�����Ϣ
function InitPatBaseBar(){
	
	runClassMethod("web.DHCEMConsultQuery","GetPatEssInfo",{"PatientID":"", "EpisodeID":EpisodeID},function(jsonString){
		var jsonObject = jsonString;
		$('.ui-span-m').each(function(){
			$(this).text(jsonObject[this.id]);
			if (jsonObject.PatSex == "��"){
				$("#PatPhoto").attr("src","../scripts/dhcnewpro/images/boy.png");
			}else if (jsonObject.PatSex == "Ů"){
				$("#PatPhoto").attr("src","../scripts/dhcnewpro/images/girl.png");
			}else{
				$("#PatPhoto").attr("src","../scripts/dhcnewpro/images/unman.png");
			}
		})
	},'json',false)
}

/// ҳ��DataGrid��ʼ������ѡ�б�
function InitPageDataGrid(){
	
	///  ����columns
	var columns=[[
		{field:'StartDate',title:'��ʼ����',width:100,align:'center'},
		{field:'StartTime',title:'��ʼʱ��',width:100,align:'center'},
		{field:'EndDate',title:'��������',width:100,align:'center'},
		{field:'EndTime',title:'����ʱ��',width:100,align:'center'},
		{field:'Ward',title:'��Ժ����',width:100,align:'center'},
		{field:'PatBed',title:'����',width:100,align:'center'},
		{field:'User',title:'������',width:100,align:'center'}
	]];
	
	///  ����datagrid
	var option = {
		//showHeader:false,
		fitColumn:true,
		rownumbers:false,
		singleSelect:true,
		pagination:true,
		fit:true,
	    onLoadSuccess:function (data) { //���ݼ�������¼�
	    	
        }
	};
	/// ��������
	var uniturl = $URL+"?ClassName=web.DHCEMRotatBed&MethodName=JsonQryPatTrsHis&EpisodeID="+ EpisodeID;
	new ListComponent('visgrid', columns, uniturl, option).Init();
}

//hxy 2020-02-20
function setCellLabel(value){
	if(value.indexOf("1��")>-1){value="��";}
	if(value.indexOf("2��")>-1){value="��";}
	if(value.indexOf("3��")>-1){value="��";}
	if(value.indexOf("4��")>-1){value="��a��";}
	if(value.indexOf("5��")>-1){value="��b��";}
	return value;
}

/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })