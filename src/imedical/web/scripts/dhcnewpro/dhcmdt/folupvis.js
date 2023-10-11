//===========================================================================================
// ���ߣ�      yangyongtao
// ��д����:   2020-03-06
// ����:	   ��ü�¼
//===========================================================================================
var PatientID = "";     /// ����ID
var EpisodeID = "";     /// ���˾���ID
var mradm = "";			/// �������ID
var CstID = "";         /// ��������ID
var McID = "";      	/// ���ID
var mcType="F"
var LgUserID = session['LOGON.USERID'];  /// �û�ID
var LgLocID = session['LOGON.CTLOCID'];  /// ����ID
var LgHospID = session['LOGON.HOSPID'];  /// ҽԺID
var LgGroupID = session['LOGON.GROUPID'] /// ��ȫ��ID
var LgParam=LgUserID+"^"+LgLocID+"^"+LgGroupID+"^"+LgHospID
/// ҳ���ʼ������
function initPageDefault(){
	
   InitPatEpisodeID();       /// ��ʼ�����ز��˾���ID
}

/// ��ʼ�����ز��˾���ID
function InitPatEpisodeID(){
	
	PatientID = getParam("PatientID");   	/// ����ID
	EpisodeID = getParam("EpisodeID");   	/// ����ID
	mradm = getParam("mradm");           	/// �������ID
	CstID = getParam("CstID");              /// ����ID
	McID = getParam("McID");             	/// ���ID
	LoadContent(CstID)
	InitMoreScreen();
}


/// �����������
function LoadContent(CstID,Type){
	runClassMethod("web.DHCMDTFolUpVis","JsFloUpLastVis",{"CstID":CstID,"McID":McID,"Type":"","LgParam":LgParam},function(jsonString){
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
		htmlstr = htmlstr + '<div style="margin-top:10px;" ids="'+ itemArr[i].McID +'">';
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
		if(itemArr[i].McType=="F"){
		  htmlstr = htmlstr + '	<a class="container"  href="#" id="'+ itemArr[i].McID +'" onclick="FolEdit(this.id)">'+$g("�༭")+'</a>'; 	/// ����ҽ�����
		}
		htmlstr = htmlstr + '</div>';
		var McContent = "";
		if ((itemArr[i].McContent != "")&(typeof itemArr[i].McContent != "undefined")){
			//McContent = itemArr[i].McContent.replace(new RegExp("<br>","g"),"\r\n")
			McContent = itemArr[i].McContent.replace(new RegExp("\n","g"),"<br>") //\r

		}
		McContent=$_TrsTxtToSymbol(McContent)       							/// �����Ϣ
		htmlstr = htmlstr + '<div  class="textarea">'+ McContent +'</div>';  	/// �����Ϣ
	}
	$("#feedback").html(htmlstr);
	 	
}

///  ��ñ༭
function FolEdit(McID){
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
    
	var mcContent = $("#mcContent").val();     /// �������
	if (mcContent.replace(/\s/g,'') == ""){
		$.messager.alert("��ʾ:","������ò���Ϊ�գ�","warning");
		return;
	}
/* 	if ((mcContent != "")&(typeof mcContent != "undefined")){
		mcContent = mcContent.replace(new RegExp("<br>","g"),"\r\n")
	} */
	mcContent = $_TrsSymbolToTxt(mcContent);        /// �����������
	
	var mListData=CstID +"@!@"+ LgLocID +"@!@"+ LgUserID +"@!@"+ mcContent +"@!@"+ mcType
	/// ����
	runClassMethod("web.DHCMDTFolUpVis","Insert",{"McID":McID, "mListData":mListData},function(jsonString){
		if(jsonString=="-1"){
			$.messager.alert("��ʾ:","���޸��ϴη�����Ϣ��","warning");
			return;
		}
		if(jsonString=="-104"){
			$.messager.alert("��ʾ:","���ݹ���,��������1000�����ڣ�","warning");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("��ʾ:","��������ύʧ�ܣ�ʧ��ԭ��:"+jsonString,"warning");
		}else{
			McID = jsonString;
			$.messager.alert("��ʾ:","�ύ�ɹ���")
			LoadContent(CstID)
			McID="";
			$("#mcContent").val("");
			
			if(window.parent.frames.length){
				window.parent.frames[1].$("#tag_id").tabs("getTab","��ü�¼").find("iframe")[0].contentWindow.InitlogDetailsList();
			}
			//$("#TimeAxis").location.reload()

		}
	},'',false)
}

/// ����
function OpenEmr(flag){

	//var url="dhcmdt.patemrque.csp?EpisodeID="+EpisodeID+"&PatientID="+PatientID;
	//dhcem.patemrque.csp?EpisodeID=1624&PatientID=671
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
	
	var frm = dhcsys_getmenuform();
	if (frm) {
		PatientID = frm.PatientID.value;
		EpisodeID = frm.EpisodeID.value;
		mradm = frm.mradm.value;
	}
	
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