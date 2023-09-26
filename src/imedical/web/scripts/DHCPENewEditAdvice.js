document.body.onload = BodyLoadHandler;
var MainAuditFlag="0";
var SaveSortInfo="";

function BodyLoadHandler()
{
	var obj=document.getElementById("EpisodeID");
	if (obj) var EpisodeID=obj.value;
	//�����ύ
	var obj=document.getElementById(EpisodeID+"^Save");
	if (obj) obj.onclick=Audit_click;
    //ȡ������
    var obj=document.getElementById(EpisodeID+"^Cancel");
	if (obj) obj.onclick=StationSCancelSub;
    //���潨��(P)
    var obj=document.getElementById(EpisodeID+"^SaveAP");
	//if (obj) obj.onclick=SaveAdvice;
	if (obj) obj.onclick=SaveAdviceApp;
	//���潨��(V)
    var obj=document.getElementById(EpisodeID+"^SaveVP");
	if (obj) obj.onclick=SaveGSSDetail;
	 //���ν��
	var obj=document.getElementById(EpisodeID+"^History");
	if (obj) obj.onclick=GetContrastWithLast;
	//����Ԥ��
	var obj=document.getElementById(EpisodeID+"^Report");
	if (obj) obj.onclick=PreviewReport;
    //��Σ
	var obj=document.getElementById(EpisodeID+"^HighRisk");
	if (obj) obj.onclick=HighRiskReport;
	//��鱨��
	var obj=document.getElementById(EpisodeID+"^CheckResult");
	if (obj) obj.onclick=ShowCheckResult;
	//�����ϱ�
	var obj=document.getElementById(EpisodeID+"^QM");
	if (obj) obj.onclick=QMManager;
     //�ϲ�
    var obj=document.getElementById("UniteAdvice");
	if (obj) obj.onclick=UniteAdvice_click;
    //�ϲ���¼
    var obj=document.getElementById("UnitRecord");
	if (obj) obj.onclick=UnitRecord;
	  //ȡ��
    var obj=document.getElementById("CancelAdvice");
	if (obj) obj.onclick=CancelAdvice;
    //���
    var obj=document.getElementById("AllSelectAdvice");
	if (obj) obj.onclick=AllSelectAdvice;

	
	
	var objArr=document.getElementsByTagName("textarea");
	var objLength=objArr.length;
	for (var i=0;i<objLength;i++)
	{
		setTareaAutoHeight(objArr[i]);
	}
	DragRowsMove("EditAdvice");
    var ObjArr1=document.getElementsByName("DeleteButton");
	var ArrLength=ObjArr1.length;
 	for (var j=0;j<ArrLength;j++)
	{
		var ID=ObjArr1[j].id;
		var ret=tkMakeServerCall("web.DHCPE.ResultDiagnosis","GetSSDiagnosisAdvice",ID);
	    var arr=ret.split("^");
		var obj=document.getElementById(ID+"^JY");
		if (obj) obj.value=arr[0];
		var obj=document.getElementById(ID+"^JL");
		if (obj) obj.value=arr[1];
	}
	var GSSDetailObj=document.getElementById("GSSDetail");
	if (GSSDetailObj)
	{
	 	 var GSID="";
	     var obj=document.getElementById("SSID");
	     if (obj) GSID=obj.value;
		 var ret= tkMakeServerCall("web.DHCPE.ResultDiagnosisNew","OutGSSDetail1",GSID);
		 var obj=document.getElementById("GSSDetail");
	     if (obj) obj.value=ret;

	}
	var MainObj=document.getElementById("MainDoctor");
	if (MainObj){
		if (MainObj.value=="Y") MainAuditFlag=1;
	}
	 inform();
}

function DragRowsMove(TableName)
{
	var curTr = null;
	var tb1 = document.getElementById(TableName);
	if (!tb1) return false;
	var trs = tb1.getElementsByTagName('TR'); 
    tb1.onselectstart = function(){ 
        if(curTr){ 
            document.selection.empty(); return true; 
        } 
    }; 
    
    for(var i=0; i<trs.length; i++) { 
        var tds = trs[i].getElementsByTagName('TD'); 
        var obj=tds[0]; //�ڶ���
        obj.style.cursor = 'move'; 
        obj.onmousedown = function(){ 
            curTr = this.parentNode; 
            curTr.style.backgroundColor = '#eff'; 
        }; 
        obj.onmouseover = function() { 
            if(curTr && curTr != this.parentNode) { 
                this.parentNode.swapNode(curTr); 
            } 
        }
		/*
        var obj=tds[3];  //������
        obj.style.cursor = 'move'; 
        obj.onmousedown = function(){ 
            curTr = this.parentNode; 
            curTr.style.backgroundColor = '#eff'; 
        }; 
        obj.onmouseover = function() { 
            if(curTr && curTr != this.parentNode) { 
                this.parentNode.swapNode(curTr); 
            } 
        }*/ 
    } 
      
    document.body.onmouseup = function(){ 
        if(curTr){ 
            curTr.style.backgroundColor = ''; 
            curTr = null; 
        } 
    };
    SaveSortInfo="1";
}
/*
function AllSelectAdvice()
{
	var objArr=document.getElementsByName("SelectAdvice");
	var objLength=objArr.length;
	for (var i=0;i<objLength;i++)
	{
		objArr[i].checked=true //!objArr[i].checked;
	}
	return false;
}*/
function inform()
{
	var objArr=document.getElementsByName("SelectAdvice");
	var objLength=objArr.length;
	
	for (var i=0;i<objArr.length;i++)
	{
	
		var flag=tkMakeServerCall("web.DHCPE.ResultDiagnosisNew","ISSaveMainCheck",objArr[i].id.split("^")[0]);
		
		if(flag==1){objArr[i].checked=true;}
		else{
			objArr[i].checked=false;
			}
	}
	
}

function AllSelectAdvice()
{
	var objArr=document.getElementsByName("SelectAdvice");
	var objLength=objArr.length;
	
	var SaveInfo="",NoUseInfo=""
	for (var i=0;i<objArr.length;i++)
	{
	
	
		if (objArr[i].checked){
			if (SaveInfo==""){
				SaveInfo=objArr[i].id.split("^")[0];
			}else{
				SaveInfo=SaveInfo+"^"+objArr[i].id.split("^")[0];
			}
		}else{
			if (NoUseInfo==""){
				NoUseInfo=objArr[i].id.split("^")[0];
			}else{
				NoUseInfo=NoUseInfo+"^"+objArr[i].id.split("^")[0];
			}
		}
	}
	
	var UserID=session['LOGON.USERID'];
	var flag=tkMakeServerCall("web.DHCPE.ResultDiagnosisNew","SaveMainCheck",SaveInfo,NoUseInfo,UserID);
	
	return false;
}

function SetSort()
{
	var GSID="",encmeth="";
	var obj=document.getElementById("SSID");
	if (!obj) obj=document.getElementById("GSID");
	if (obj) GSID=obj.value;
	var obj=document.getElementById("SetSortClass");
	if (obj) encmeth=obj.value;
	var ret=cspRunServerMethod(encmeth,GSID);
	SaveSortInfo="0";
	window.location.reload();
}
function UnitRecord()
{
	var GSID="";
	var obj=document.getElementById("GSID");
	if (obj) GSID=obj.value;
	
	
	
	var wwidth=600;
	var wheight=400; 
	var xposition = (screen.width - wwidth) / 2;
	var yposition = (screen.height - wheight) / 2;
	var nwin='toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=no,resizable=yes,copyhistory=yes'
			+',height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPEGSDUnitRecord&GSID="+GSID;
	open(lnk,"_blank",nwin);
	return false;
}
//function UniteAdvice()
function UniteAdvice_click()
{
	//if (!confirm(t['Unite'])) return false;
	var Char_13=String.fromCharCode(13);
	var HBObj,HBID="",HBAdviceJL="",HBAdviceJY="",CancelIDs="",AdviceJL="",AdviceJY="";
	var objArr=document.getElementsByName("Unite");
	var objLength=objArr.length;
	var JL="",JY="";
	
	var flag=0;
	for (var i=objLength;i>0;i--)
	{
		if (objArr[i-1].checked){
			var flag=1;
			
		}
	}
	if(flag=="0"){
		alert("��ѡ��Ҫ�ϲ��Ľ���");
		return false;
	}
	if (!confirm(t['Unite'])) return false;

	
	for (var i=objLength;i>0;i--)
	{
		if (objArr[i-1].checked){
			var ID=objArr[i-1].id;
			var GSSID=ID.split("^")[0];
			var obj=document.getElementById(GSSID+"^JL");
			if (obj) JL=obj.value;
			var obj=document.getElementById(GSSID+"^JY");
			if (obj) JY=obj.value;
			if (AdviceJL==""){
				AdviceJL=JL;
				AdviceJY=JY;
			}else{
				AdviceJL=JL+""+Char_13+""+AdviceJL;
				AdviceJY=JY+","+AdviceJY;
			}
			if (!HBObj){
				HBObj=objArr[i-1];
				HBObj.checked=false;
				HBID=GSSID;
				HBAdviceJL=JL;
				HBAdviceJY=JY;
			}else{
				if (CancelIDs==""){
					CancelIDs=GSSID;
				}else{
					CancelIDs=CancelIDs+","+GSSID;
				}
				var obj=document.getElementById(GSSID);
				if (obj) DeleteAdvice(obj,0);
			}
		}
	}
	if ((HBObj)&&(CancelIDs!="")){
		var encmeth="";
		var HoldInfo=HBID+"^"+HBAdviceJL+"^"+HBAdviceJY;
		var obj=document.getElementById("UnitClass");
		if (obj) encmeth=obj.value;
		var UserID=session['LOGON.USERID']
		var ret=cspRunServerMethod(encmeth,HoldInfo,CancelIDs,UserID);
		var ID=HBObj.id;
		var GSSID=ID.split("^")[0];
		var obj=document.getElementById(GSSID+"^JL");
		if (obj) obj.value=AdviceJL;
		var obj=document.getElementById(GSSID+"^JY");
		if (obj) obj.value=AdviceJY;
		setTareaAutoHeight(HBObj);
		SaveAdviceApp(0)
	}
	return false;
}
function SaveAdvice(CloseFlag)
{
	SaveAdviceApp(1);
}
function SaveAdviceApp(CloseFlag)
{
	var ObjArr=document.getElementsByName("DeleteButton");
	var ArrLength=ObjArr.length;	
	var Strings="",Remark="",OEItemId="",EDCRowId="";
	for (var i=0;i<ArrLength;i++)
	{
		var tr=ObjArr[i].parentNode.parentNode;
		var Sort=tr.rowIndex+1;
		var ID=ObjArr[i].id;
		var Advice="";
		var obj=document.getElementById(ID+"^JY");
		if (obj) Advice=obj.value;
		obj=document.getElementById('TReCheckz'+i);
		var ReCheck="N";
		var obj=document.getElementById(ID+"^MD");
		if(obj){
			if (obj.checked){ReCheck="Y" }
			else{
				/*
				if ((MainAuditFlag=="1")&&(confirm("��"+(i+1)+"��ȷʵҪɾ����")))
				{
					ReCheck="N";
				}else{
					ReCheck="Y";
				}
				*/
			}
		}
		var DisplayDesc="";
		var obj=document.getElementById(ID+"^JL");
		if (obj) DisplayDesc=obj.value;
		//alert(Sort+"^"+DisplayDesc)
		if (Strings=="")
		{
			Strings=ID+"&&"+Remark+"&&"+Advice+"&&"+Sort+"&&"+EDCRowId+"&&"+OEItemId+"&&"+DisplayDesc+"&&"+ReCheck;
		}
		else
		{
			Strings=Strings+"^"+ID+"&&"+Remark+"&&"+Advice+"&&"+Sort+"&&"+EDCRowId+"&&"+OEItemId+"&&"+DisplayDesc+"&&"+ReCheck;
		}
	
	}
	if (Strings=="") {
		alert("����ͽ���Ϊ��");
		return false;
	}
		
	var obj=document.getElementById("UpdateClass");
	if (obj) var encmeth=obj.value;
	var MainDoctor="";
	var obj=document.getElementById("MainDoctor");
	if (obj) MainDoctor=obj.value;
	var flag=cspRunServerMethod(encmeth,Strings,MainDoctor);
	if (SaveSortInfo!=""){
		var GSID="";
		var obj=document.getElementById("GSID");
		if (obj) GSID=obj.value;
		//alert(GSID)
		var ret= tkMakeServerCall("web.DHCPE.ResultDiagnosisNew","SaveSortInfo",GSID,SaveSortInfo);
	} 
	if (CloseFlag==0) return false;
	  window.location.reload();
	if (opener){
		opener.location.reload();
	}
	window.returnValue=1;
	window.close();
}
function DeleteAdvice(e,ConfirmFlag)
{
	var DeleteType=1;  //���ϲ�
	if(ConfirmFlag==1){
		if (!confirm(t['Del'])) return false;
		DeleteType=2;  //��ɾ��
	}
	var ID=e.id;
	var obj=document.getElementById("DeleteClass");
	if (obj) var encmeth=obj.value;
	if (ID=="") return false;
	var SSID=ID.split("||")[0];
	var MainDoctor="";
	var obj=document.getElementById("MainDoctor");
	if (obj) MainDoctor=obj.value;
	var flag=cspRunServerMethod(encmeth,SSID,ID,DeleteType,MainDoctor);
	DeleteTableRow(e);
	//window.location.reload();
}
function DeleteTableRow(e)
{
	var Rows=e.parentNode.parentNode.rowIndex;
	var TableObj=document.getElementById("EditAdvice");
	TableObj.deleteRow(Rows);

}
function CancelAdvice()
{
	window.returnValue=0;
	window.close();
}
function setTareaAutoHeight(e) {
    //e.style.height = e.scrollHeight + "px";
	if (e.scrollHeight<32){
		e.style.height=32+"px";
	}else{
		e.style.height = e.scrollHeight + "px";
	}
}