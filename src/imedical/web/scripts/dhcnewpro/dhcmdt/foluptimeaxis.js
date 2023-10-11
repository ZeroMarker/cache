//===========================================================================================
// ���ߣ�      yangyongtao
// ��д����:   2020-03-10
// ����:	   ��ñ�ʱ����JS
//===========================================================================================

var CstID = "";     	/// ����ID
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
	
	CstID =getParam("CstID");            /// ����ID
	InitTimeAxis(CstID)
}


///  ʱ����
function InitTimeAxis(CstID){

	runClassMethod("web.DHCMDTFolUpVis","JsMcTimeAxis",{"CstID":CstID,"LgParam":""},function(jsonString){
		
		if (jsonString != null){
			InsTimeAxis(jsonString);
		}
	},'json',false)
}

///  ʱ����
function InsTimeAxis(itemArr){
	
	var htmlstr = "";
	var McType=""
	for (var i=0; i<itemArr.length; i++){
    
		htmlstr = htmlstr + '<li id="'+ itemArr[i].McID +'">';
		htmlstr = htmlstr + '	<div class="circle"></div>';
		
		
		if(itemArr[i].McType=="F"){
			McType=$g("��")+itemArr[i].FTimes+$g("���")
		}else{
		 	McType=$g("ר�����")
	    }
    	if(itemArr[i].Type=="Log"){
			htmlstr = htmlstr + '<div class="txt">'+ itemArr[i].StatusDesc +'<span style="margin-left:10px;">'+itemArr[i].McUser +'</span><span style="margin-left:10px;">'+ itemArr[i].McDate +'</span><span style="margin-left:10px;">'+ itemArr[i].McTime +'</span></div>';
		}else{
			htmlstr = htmlstr + '<div class="txt">'+ McType +'<span style="margin-left:10px;">'+itemArr[i].McUser +'</span><span style="margin-left:10px;">'+ itemArr[i].McDate +'</span><span style="margin-left:10px;">'+ itemArr[i].McTime +'</span></div>';
        }
        
        var McContent = itemArr[i].McContent
        McContent = McContent.replace(/\n/g,"<br>");
		
		if(itemArr[i].Status=="20"){
			htmlstr = htmlstr + '	<div  class="content">'+ $g("����ժҪ")+"��"+itemArr[i].CstTrePro +'<br/>'+$g("����Ŀ��")+"��"+itemArr[i].CstPurpose+'</div>';
			//htmlstr = htmlstr + '	<div  class="trepro">'+ "����Ŀ�ģ�"+itemArr[i].CstPurpose +'</div>';
		}else if(itemArr[i].Status=="40"){
			htmlstr = htmlstr + '	<div id="content" class="content">'+ itemArr[i].DisProcess +'</div>';
		}else if(itemArr[i].Status=="80"){
			htmlstr = htmlstr + '	<div id="content" class="content">'+ $g("��������")+":"+itemArr[i].DisProcess+"<br/>"+$g("�������")+":"+itemArr[i].TreMeasures +'</div>';
		}else{
			htmlstr = htmlstr + '	<div id="content" class="content">'+ McContent +'</div>';
		}
		htmlstr = htmlstr + '</li>';
		
	}
	$(".timeaxis ul").html(htmlstr);
	$(".timeaxis ul li").addClass("li_active");	
	
}

/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })