//===========================================================================================
// ���ߣ�      yangyongtao
// ��д����:   2020-03-10
// ����:	   �����¼
//===========================================================================================
var PatientID = "";     /// ����ID
var EpisodeID = "";     /// ���˾���ID
var mradm = "";			/// �������ID
var McID = "";      	/// ���ID
var CstID = "";         /// ����ID
var mcType="R"
var ParentDr=""
var LgUserID = session['LOGON.USERID'];  /// �û�ID
var LgLocID = session['LOGON.CTLOCID'];  /// ����ID
var LgHospID = session['LOGON.HOSPID'];  /// ҽԺID
var LgGroupID = session['LOGON.GROUPID'] /// ��ȫ��ID
var LgParam=LgUserID+"^"+LgLocID+"^"+LgGroupID+"^"+LgHospID
var del = String.fromCharCode(2);
/// ҳ���ʼ������
function initPageDefault(){
	
   	InitPatEpisodeID();       /// ��ʼ�����ز��˾���ID

	InitMoreScreen();
}

/// ��ʼ�����ز��˾���ID
function InitPatEpisodeID(){
	
	PatientID = getParam("PatientID");   	/// ����ID
	EpisodeID = getParam("EpisodeID");   	/// ����ID
	mradm = getParam("mradm");           	/// �������ID
	CstID = getParam("CstID");              /// ����ID
	ParentDr = getParam("McID");            /// ���ID
	if(ParentDr==""){
		ParentDr=$.cm({ 
			ClassName:"web.DHCMDTFolUpVis",
			MethodName:"GetLastMcID",
			ID:CstID,
			dataType:"text"
		}, false);
	}
	if(ParentDr==""){
		$.messager.alert("��ʾ", "û�м�⵽������Ϣ,��ֹ�ظ�!","warning");
		$("#submitBut").linkbutton('disable');
		$("#mdtSignCsBut").linkbutton('disable');
		return;	
	}
	LoadContent(CstID)
}


/// �����������
function LoadContent(CstID,Type){
	runClassMethod("web.DHCMDTFolUpVis","JsFloUpVis",{"CstID":CstID,"McID":ParentDr,"Type":"","LgParam":LgParam},function(jsonString){
		if (jsonString != null){
			InsMcPanel(jsonString);
		}
	},'json',false)
}

/// ����ҳ���������
function InsMcPanel(itemArr){
	var htmlstr = "";
	var McType=""
	for (var i=0; i<itemArr.length; i++){
		htmlstr = htmlstr + '<div style="margin-top:10px;" id="'+ itemArr[i].McID +'">';
		if(itemArr[i].McType=="F"){
		  McType=$g("����");
		  htmlstr = htmlstr + '	<span class="fuvis">'+ McType +'</span >'; 	/// ���(�ظ�)����
		}else{
		  McType=$g("���");
		  htmlstr = htmlstr + '	<span class="reply">'+ McType +'</span >'; 	/// ���(�ظ�)����
	    }
		htmlstr = htmlstr + '	<span class="container">'+ itemArr[i].McLoc +'</span >'; 	/// ���(�ظ�)����
		htmlstr = htmlstr + '	<span  class="container">'+ itemArr[i].McUser +'</span>'; 	/// ���ҽʦ/�ظ�ר��
		htmlstr = htmlstr + '	<span  class="container">'+ itemArr[i].McDate +'</span>'; 	/// ���(�ظ�)����
		if(itemArr[i].McType=="R"){
		  htmlstr = htmlstr + '	<a class="container"  href="#" id="'+ itemArr[i].McID +'" onclick="ReplyEdit(this.id)">'+$g("�༭")+'</a>'; 	/// ר�ҽ���
		}
		htmlstr = htmlstr + '</div>';
		var McContent = "";
		if ((itemArr[i].McContent != "")&(typeof itemArr[i].McContent != "undefined")){
			//McContent = itemArr[i].McContent.replace(new RegExp("<br>","g"),"\r\n")
		    McContent = itemArr[i].McContent.replace(new RegExp("\n","g"),"<br>") //\r

		}
		McContent=$_TrsTxtToSymbol(McContent) 
		htmlstr = htmlstr + '<div  class="textarea">'+ McContent +'</div>';  	/// �����Ϣ
	    $("#Opinion").html(itemArr[i].TreMeasures)  //�������

	}
	$("#Reply").html(htmlstr);
	 	
}

///  ��ñ༭
function ReplyEdit(McID){
	runClassMethod("web.DHCMDTFolUpVis","GetMcContent",{"McID":McID},function(jsonString){
		
		if (jsonString != null){
			getContent(jsonString);
		}
	},'json',false)
}


/// ��ȡ�������
function getContent (itemObj){
	McID = itemObj.McID;
	$("#mcContent").val(itemObj.McContent);
	
}

/// �ύ��ü�¼
function SubmitBut(){
	
	//ר���Ƿ��Ѿ�ǩ������
	if(McID!=""){
		var IsCASign=IsgetsignmdtSIGNID(McID)
		if(IsCASign!=1){
			//$.messager.alert("��ʾ", "����ר���Ѿ�ǩ��,�����޸ı��ν��飡","warning")	
		    //return;
		}
	}
	
	var mcContent = $("#mcContent").val();     /// �������
	if (mcContent.replace(/\s/g,'') == ""){
		$.messager.alert("��ʾ:","���ν��鲻��Ϊ�գ�","warning");
		return;
	}
	mcContent = $_TrsSymbolToTxt(mcContent);        /// �����������
	
	var mListData=CstID +"@!@"+ LgLocID +"@!@"+ LgUserID +"@!@"+ mcContent +"@!@"+ mcType
	/// ����
	runClassMethod("web.DHCMDTFolUpVis","Insert",{"McID":McID, "mListData":mListData,"ParentDr":ParentDr},function(jsonString){
		if(jsonString=="-1"){
			$.messager.alert("��ʾ:","���޸�ר�ҽ�����Ϣ��","warning");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("��ʾ:","���ν����ύʧ�ܣ�ʧ��ԭ��:"+jsonString,"warning");
		}else{
			McID = jsonString;
			$.messager.alert("��ʾ:","�ύ�ɹ���")
			LoadContent(CstID);
			$("#mcContent").val("");
		}
	},'',false)
}

/// ����
function OpenEmr(flag){
	
	var url = "dhcem.patemrque.csp?&EpisodeID="+EpisodeID+"&PatientID="+PatientID+"&Type=2"+"&MWToken="+websys_getMWToken(); //+obj.text;
	//"dhcem.quote.csp?PatientID=61&amp;EpisodeID=73&amp;Type=2"
	websys_showModal({
		url: url,
		iconCls:"icon-w-paper",
		title: "����",
		closed: true,
		//width:parseInt($(window.parent).width())-100,height:parseInt($(window.parent).height())-50,
		width:1280,
		height:600,
		InsQuote:function(resQuote ,Flag){
			if ($("#mcContent").val() == ""){
				$("#mcContent").val(resQuote);  		/// ����
			}else{
				$("#mcContent").val($("#mcContent").val()  +"\r\n"+ resQuote);
			}
		},
		onClose:function(){}
	});
	return;

	//var url="dhcmdt.patemrque.csp?EpisodeID="+EpisodeID+"&PatientID="+PatientID;
	var url = "dhcem.consultpatemr.csp?&EpisodeID="+EpisodeID+"&PatientID="+PatientID+"&targetName=Attitude"+"&TextValue="+"&MWToken="+websys_getMWToken(); //+obj.text;
	var result = window.showModalDialog(url,"_blank",'dialogWidth:1280px;DialogHeight=600px;center=1'); 
	try{
		if (result){
			if ($("#MCContent").val() == ""){
				$("#MCContent").val(result.innertTexts);  		/// ����
			}else{
				$("#MCContent").val($("#MCContent").val()  +"\r\n"+ result.innertTexts);  		/// ��Ҫ����
			}
		}
	}catch(ex){}
}

/// ����ҽ��¼�봰��
function OpenCsOrderWin(){
	
	if (EpisodeID == ""){
		$.messager.alert("��ʾ:","��ѡ������¼�����ԣ�","warning");
		return;
	}
	var lnk = "dhcem.consultorder.csp?PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&mradm="+ mradm+"&MWToken="+websys_getMWToken();
	websys_showModal({
		url:lnk,
		title:'ҽ��¼��',
		width:screen.availWidth-150,height:screen.availHeight-150,
		onClose: function() {
			tkMakeServerCall("web.DHCDocMainOrderInterface","ChartItemChange");
		}
	});
}

/// ǩ��
function mdtSignCs(){
	
	if (McID == ""){
		$.messager.alert("��ʾ:","mdt����ר�Ҳ���Ϊ�գ�","warning");
		return;
	}
	
	//ר���Ƿ��Ѿ�ǩ������
	var IsCASign=IsgetsignmdtSIGNID(McID)
	if(IsCASign!=1){
		$.messager.alert("��ʾ", "����ר���Ѿ�ǩ��,�����ظ�ǩ����","warning")	
	    return;
	}
	
	InvDigSign(CstID,McID); /// ��������ǩ��
}



function InitMoreScreen(){
	if(!IsOpenMoreScreen) return;
	
	ShowEmrScr();
	
	ListenRetValue();
}
function ListenRetValue(){
	websys_on("onMdtRefData",function(res){
		if(res.flag===''){
			var nowValue = $("#mcContent").val();
			$("#mcContent").val( nowValue+(nowValue?'\r\n':'')+res.text);
		}
	});
}


/// �����鿴:���ں�
function ShowEmrScr(){
	if(!IsOpenMoreScreen) return;

	var Obj={
		PatientID:PatientID,
		EpisodeID:EpisodeID,
		Type:2,
		EpisodeLocID:session['LOGON.CTLOCID'],
		Action:"externalapp"
	}
	
	websys_emit("onMdtConsWriteOpen",Obj);
}

/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })