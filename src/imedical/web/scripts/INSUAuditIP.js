//INSUAuditIP.js
var Flag=""
var iSeldRow=0
var AdmRowid="",BillDr="",AdmDr="",EpisodeID=""
var theInterval
function BodyLoadHandler() {
	Guser=session['LOGON.USERID'];
	GuserName=session['LOGON.USERNAME'];
	var obj=document.getElementById("RegNo") ;
	if (obj)
	{
		PapmiNo=obj.value;
		obj.onkeydown=PapmiNo_onkeydown;
	}
	var objtbl=document.getElementById("tINSUAuditIP") ;
	var obj=document.getElementById("MediCare") ;   //add 2012-01-09
    var now= new Date()
    var hour= now.getHours();
	/*if (objtbl)
	{
		//objtbl.ondblclick=RowChanged;
		for (i=1;i<objtbl.rows.length;i++)
		{
			var item=document.getElementById("Selectz"+i);
			if(item){item.checked=true;} //2011-08-03
			var TabAuditFlag=document.getElementById("TabAuditFlagz"+i).innerText;
 			if ((TabAuditFlag==" "))
			{
				if(item){item.checked=true;} //2011-08-03
			}
		}
	}*/
	
	var Audit=document.getElementById("BtnAudit") ;
	if (Audit)  Audit.onclick=Audit_Click;
	var Refuse=document.getElementById("BtnRefuse") ;
	if (Refuse)  Refuse.onclick=Refuse_Click;
	var ResumeObj=document.getElementById("BtnResume") ;
	if (ResumeObj)  ResumeObj.onclick=Resume_Click;
	//Lou 2011-08-04		
	obj=document.getElementById("AuditDic");
	if (obj){obj.onchange=SelectAuditDic;}
	var SaveObj=document.getElementById("btnSave") ;
	if (SaveObj)  SaveObj.onclick=btnSave_Click;		//Save_Click
	var BtnFind=document.getElementById("BtnFind") ;
	if (BtnFind)  BtnFind.onclick=BtnFind_Click;
	var BtnOutPut=document.getElementById("BtnOutPut") ;
	if (BtnOutPut)  BtnOutPut.onclick=Print_Click;
	var BtnStAudit=document.getElementById("BtnStAudit"); //2011-10-28
	if(BtnStAudit){BtnStAudit.onclick=BtnStAudit_Click;}
	var obj=document.getElementById("CheckAuditFlag");
	if (obj){obj.onchange=CheckAuditFlag_Change;}
	var BtnAuditBack=document.getElementById("BtnAuditBack");  //2011-11-11
	if (BtnAuditBack){BtnAuditBack.onclick=BtnAuditBack_Click;}
    	var AddDepInfo=document.getElementById("AddDepInfo");  //2011-11-11
	if (AddDepInfo){AddDepInfo.onclick=AddDepInfo_Click;}
	var ReceiveInfo=document.getElementById("BtnReceive");  //2011-11-11
	if (ReceiveInfo){ReceiveInfo.onclick=ReceiveInfo_Click;}
	var ReceiveInfo=document.getElementById("IPOutPut");  //2011-12-30 ���õ���
	if (ReceiveInfo){ReceiveInfo.onclick=IPOutPut_Click;}
	obj=document.getElementById("AuditDicDetail");  //2011-12-31
	if (obj){obj.onchange=SelectAuditDicDetail;}
	var obj=document.getElementById("CheckInPat");  //2012-01-14
	if (obj){obj.onchange=CheckInPat_Change;}
	ini()
	getpath();
	TimerQuery()
	var StartTimerObj=document.getElementById("startTimer") ;
	if (StartTimerObj)  StartTimerObj.onclick=StartTimer_Click;
	var ClearTimerObj=document.getElementById("ClearTimer") ;
	if (ClearTimerObj)  ClearTimerObj.onclick=ClearTimer_Click;
}
function StartTimer_Click() {
	alert("��ʼ�Զ���ѯ")
	var TimerFlagObj=document.getElementById("TimerFlag") ;
	if (TimerFlagObj) TimerFlagObj.value="Y"
	theInterval=setInterval("WindowReload()",10000)
	}
function ClearTimer_Click() {
	var TimerFlagObj=document.getElementById("TimerFlag") ;
	if (TimerFlagObj) TimerFlagObj.value="N"
	clearInterval(theInterval)
	alert("ֹͣ�Զ���ѯ")
	}
function TimerQuery() {
	var TimerFlagObj=document.getElementById("TimerFlag") ;
	if (TimerFlagObj.value=="Y") {theInterval=setInterval("WindowReload()",10000)}
	}
function WindowReload(){
	var TimerFlagObj=document.getElementById("TimerFlag") ;
	var StartDateObj=document.getElementById("StartDate") ;
	var CheckAuditFlagObj=document.getElementById("CheckAuditFlag") 
	var CheckInPatObj=document.getElementById("CheckInPat") 
	
	
	var str='websys.default.csp?WEBSYS.TCOMPONENT=INSUAuditIP&TimerFlag='+TimerFlagObj.value+'&StartDate='+StartDateObj.value+'&CheckAuditFlag='+CheckAuditFlagObj.value+'&CheckInPat='+CheckInPatObj.value;
    location.href=str
	}

	
function ini()
{
	var obj=document.getElementById("CheckInPat"); //��ѯģʽ Lou 2011-10-14
	if (obj){	
	  	obj.size=1; 
	  	obj.multiple=false;
	  	obj.options[0]=new Option("��Ժ",1);
	  	obj.options[1]=new Option("��Ժδ����",2);
	  	obj.options[2]=new Option("�Ѳ������",3);
	  	obj.selectedIndex=1
	}
	var svalue = window.location.search.match( new RegExp( "[\?\&]" + "CheckInPat" + "=([^\&]*)(\&?)", "i" ) ); 
	svalue=svalue?svalue[1]:svalue;
	if(svalue!=null)   //Lou 2011-11-10 ��λ
	{
		for (var j=0;j<obj.options.length;j++)
		{
			if (obj.options[j].value==svalue)
			{
				obj.selectedIndex=j;
			}
		}
	}
    var CheckInPatobj=document.getElementById("CheckInPat")
	if (CheckInPatobj.value=="1"){  //add 2011 12 31  ��Ժ����ֻ�ܲ鿴�����ܽ����κβ���
		var BtnAudit=document.getElementById("BtnAudit");
		if (BtnAudit){
			//BtnAudit.disabled=true;
			DisBtn(BtnAudit)	//Zhan 20160526
			}
		var BtnStAudit=document.getElementById("BtnStAudit");
		if (BtnStAudit){
			//BtnStAudit.disabled="true";
			//$('BtnStAudit').style.color='#ADAA9C'	//Zhan 20160526
				DisBtn(BtnStAudit)	//Zhan 20160526
			}
		var BtnSave=document.getElementById("btnSave");
		if (BtnSave){
			//BtnSave.disabled=true;
			DisBtn(BtnSave)	//Zhan 20160526
			}
		var BtnAuditBack=document.getElementById("BtnAuditBack");
		if (BtnAuditBack){
			//BtnAuditBack.disabled=true;
			DisBtn(BtnAuditBack)	//Zhan 20160526
			}	
		var obj=document.getElementById("BtnOutPut");   //add hwq 2012-01-12
		//if(obj){DisBtn(obj);}
		var obj=document.getElementById("IPOutPut");    //modify liusf 2012 033 0
		if(obj){
			//DisBtn(obj);
			DisBtn(obj)	//Zhan 20160526
		}	
		}

	if (CheckInPatobj.value=="3"){  //add 2012 03 30  �ѽ��㻼��ֻ�ܲ鿴�����ܽ����κβ���
		//var BtnAudit=document.getElementById("BtnAudit");
		//if (BtnAudit){
		//	BtnAudit.disabled=true;
		//	}
		var BtnStAudit=document.getElementById("BtnStAudit");
		if (BtnStAudit){
			//BtnStAudit.disabled=true;
			DisBtn(BtnStAudit)	//Zhan 20160526
			}
		var BtnSave=document.getElementById("btnSave");
		if (BtnSave){
			//BtnSave.disabled=true;
			DisBtn(BtnStAudit)	//Zhan 20160526
			}
		var BtnAuditBack=document.getElementById("BtnAuditBack");
		if (BtnAuditBack){
			//BtnAuditBack.disabled=true;
			DisBtn(BtnStAudit)	//Zhan 20160526
			}	
		//var obj=document.getElementById("BtnOutPut");   //add hwq 2012-01-12
		//if(obj){DisBtn(obj);}
		//var obj=document.getElementById("IPOutPut");    //modify liusf 2012 033 0
		//if(obj){DisBtn(obj);}	
		}

		
	var obj=document.getElementById("CheckAuditFlag"); //���״̬ Lou 2011-10-19
	if (obj){	
	  	obj.size=1; 
	  	obj.multiple=false;
		obj.options[0]=new Option("�����",1);
	  	obj.options[1]=new Option("�����",2);
	  	obj.options[2]=new Option("�����",3);
	  	obj.options[3]=new Option("ȫ��","");//modefy by zhangdongliang at 2016-10-18 for Option ��Desc��Code��Ҫ�Ҹġ��Ҽӣ�������ڰ�ť�Ƿ���õ��жϾʹ��ˡ�
	  	obj.selectedIndex=0
	}
	var svalue = window.location.search.match( new RegExp( "[\?\&]" + "CheckAuditFlag" + "=([^\&]*)(\&?)", "i" ) ); 
	svalue=svalue?svalue[1]:svalue;
	if(svalue!=null)   //Lou 2011-11-10 ��λ
	{
		for (var j=0;j<obj.options.length;j++)
		{
			if (obj.options[j].value==svalue)
			{
				obj.selectedIndex=j;
			}
		}
	}
	/*var obj=document.getElementById("ReceiveFlag"); //סԺ������״̬ hwq 2011-11-21
	if (obj){	
	  	obj.size=1; 
	  	obj.multiple=false;
	  	obj.options[1]=new Option("�ѽ���",1);
	  	obj.options[2]=new Option("δ����",2);	  

	var svalue = window.location.search.match( new RegExp( "[\?\&]" + "ReceiveFlag" + "=([^\&]*)(\&?)", "i" ) ); 
	svalue=svalue?svalue[1]:svalue;
	if(svalue!=null)   //Lou 2011-11-10 ��λ
	{
		for (var j=0;j<obj.options.length;j++)
		{
			if (obj.options[j].value==svalue)
			{
				obj.selectedIndex=j;
			}
		}
	}
		}
	//����ֵ�
	var VerStr="";
	VerStr=tkMakeServerCall("web.INSUDicDataCom","GetSys","","","AuditDic");
	if ((VerStr=="0")||(VerStr=="")){
		return false;
	}
	var obj=document.getElementById("AuditDic");
	if(obj)
	{
		obj.size=1; 
	  	obj.multiple=false;
		var i,j=1
		var VerArr1=VerStr.split("!");
		for(i=1;i<VerArr1.length;i++)
		{
			var VerArr2=VerArr1[i].split("^");
			if((VerArr2[2]==Guser)||(VerArr2[2]=="1")) //ֻ��ʾ������Աά�����ֵ��빫�����ֵ�����
			{
				obj.options[j]=new Option(VerArr2[3],VerArr2[3]);
				j=j+1
			}
		}
	}
	//��Ŀ����ֵ�  2011 12 31
	var VerStr="";
	VerStr=tkMakeServerCall("web.INSUDicDataCom","GetSys","","","AuditDicDetail");
	if ((VerStr=="0")||(VerStr=="")){
		return false;
	}
	var obj=document.getElementById("AuditDicDetail");
	if(obj)
	{
		obj.size=1; 
	  	obj.multiple=false;
		var i,j=1
		var VerArr1=VerStr.split("!");
		for(i=1;i<VerArr1.length;i++)
		{
			var VerArr2=VerArr1[i].split("^");
			if((VerArr2[2]==Guser)||(VerArr2[2]=="1")) //ֻ��ʾ������Աά�����ֵ��빫�����ֵ�����
			{
				obj.options[j]=new Option(VerArr2[3],VerArr2[3]);
				j=j+1
			}
		}
	}

	//Lou 2011-10-14 �����б�
	var VerStr="";
	VerStr=tkMakeServerCall("web.INSUAuditIP","getiploc","");
	//VerStr="1^����1!2^����2!3^����3"
	var LocStr="";   //add 2011 11 14
	LocStr=tkMakeServerCall("web.INSUAuditIP","GetDepInfo",Guser);
	//if (LocStr=="-1"){var VerLocInfo="0"}
	var VerLocInfo=LocStr.split("^");
	
	var obj=document.getElementById("DepList");
	if(obj)
	{
		//obj.size=1; 
	  	//obj.multiple=false;
		var i,j=0
		var VerArr1=VerStr.split("!");
		for(i=0;i<VerArr1.length;i++)
		{
			var VerArr2=VerArr1[i].split("^");
			obj.options[j]=new Option(VerArr2[1],VerArr2[0]);
			//add 2011 11 14 hwq ��ȡ����ģ��
			var k=0
			for(k=0;k<VerLocInfo.length;k++){
				if (obj.options[j].value==VerLocInfo[k]){
					//alert(obj.options[j].value+"&"+VerLocInfo[k])
					obj.options[i].selected=true
				}
			}
			//end 2011 11 14
			j=j+1
		}
	}*/

	//modefy by zhangdongliang at 2017-02-28 for ��װ CheckAuditFlag�������߼�
	CheckAuditFlagAbled()

	if (CheckInPatobj.value=="3"){  //add 2012 03 30  �ѽ��㻼��ֻ�ܲ鿴�����ܽ����κβ���
		var BtnAudit=document.getElementById("BtnAudit");
		if (BtnAudit){
			//BtnAudit.disabled=true;
			DisBtn(BtnAudit)	//Zhan 20160526
			}
		var BtnStAudit=document.getElementById("BtnStAudit");
		if (BtnStAudit){
			//BtnStAudit.disabled=true;
			DisBtn(BtnStAudit)	//Zhan 20160526
			}
		var BtnSave=document.getElementById("btnSave");
		if (BtnSave){
			//BtnSave.disabled=true;
			DisBtn(BtnSave)	//Zhan 20160526
			}
		var BtnAuditBack=document.getElementById("BtnAuditBack");
		if (BtnAuditBack){
			//BtnAuditBack.disabled=true;
			DisBtn(BtnAuditBack)	//Zhan 20160526
			}	
		//var obj=document.getElementById("BtnOutPut");   //add hwq 2012-01-12
		//if(obj){DisBtn(obj);}
		//var obj=document.getElementById("IPOutPut");    //modify liusf 2012 033 0
		//if(obj){DisBtn(obj);}	
		}

	if (CheckInPatobj.value=="1"){  //add 2011 12 31  ��Ժ����ֻ�ܲ鿴�����ܽ����κβ���
		var BtnAudit=document.getElementById("BtnAudit");
		if (BtnAudit){
			//BtnAudit.disabled=true;
			DisBtn(BtnAudit)	//Zhan 20160526
			}
		var BtnStAudit=document.getElementById("BtnStAudit");
		if (BtnStAudit){
			//BtnStAudit.disabled=true;
			DisBtn(BtnStAudit)	//Zhan 20160526
			}
		var BtnSave=document.getElementById("btnSave");
		if (BtnSave){
			//BtnSave.disabled=true;
			DisBtn(BtnSave)	//Zhan 20160526
			}
		var BtnAuditBack=document.getElementById("BtnAuditBack");
		if (BtnAuditBack){
			//BtnAuditBack.disabled=true;
			DisBtn(BtnAuditBack)	//Zhan 20160526
			}	
		var obj=document.getElementById("BtnOutPut");   //add hwq 2012-01-12
		//if(obj){DisBtn(obj);}
		var obj=document.getElementById("IPOutPut");    //modify liusf 2012 033 0
		if(obj){DisBtn(obj);}	
		}

}

function GetSelectItem()
{
	var TabOEORIRowIdStr=""
	var OEORIRowId=""
	var objtbl=document.getElementById("tINSUAuditIP") ;
	if (objtbl)
	{
		for (i=1;i<objtbl.rows.length;i++)
		{
			//Lou 2011-08-03
			var OEORIRowId=document.getElementById("TabOEORIRowIdz"+i).value
			if(TabOEORIRowIdStr=="") var TabOEORIRowIdStr=OEORIRowId
			else   var TabOEORIRowIdStr=TabOEORIRowIdStr+"^"+OEORIRowId
		SelRowObj=document.getElementById('TabAdmRowidz'+selectrow);
		if (SelRowObj){AdmRowid=SelRowObj.value;
			AdmDr=AdmRowid;   //add 2011 11 14
			}
			/*var item=document.getElementById("Selectz"+i);
			if(item.checked==true)
			{
				var OEORIRowId=document.getElementById("TabOEORIRowIdz"+i).value
				if(TabOEORIRowIdStr=="") var TabOEORIRowIdStr=OEORIRowId
				else   var TabOEORIRowIdStr=TabOEORIRowIdStr+"^"+OEORIRowId
			}*/
		}
	}
	//alert(TabOEORIRowIdStr)
	return TabOEORIRowIdStr

}

function btnSave_Click()
{
	var obj=document.getElementById("btnSave"); //2011-10-28
	if(obj.disabled==true){return;}
	//add by zhangdongliang at 2015-10-12 for ��ѡ������ʱ���˳�������
	var SelRowObj=document.getElementById('TabAuditFlagz'+iSeldRow);   //2011 12 31
	if (SelRowObj){}
	else
	{
		alert("��ѡ��һ����¼")
		return;
	}
	
	if (SelRowObj.innerText!=="��ʼ���") {
		alert("���״̬����'��ʼ���',���ܱ���")
		return;
		}
	var SelRowObj=document.getElementById('TabAuditUserNamez'+iSeldRow);   //add 2012-01-12 
	if ((SelRowObj.innerText!=GuserName)){
		alert("�û�������������Ա��ˡA������ˡI")
		return;
		}
	Save_Click();  //������ʱ�Զ����� 2011 12 26
}
function Audit_Click()
{
	var obj=document.getElementById("BtnAudit"); //2011-10-28
	if(obj.disabled==true){return;}
	//add by zhangdongliang at 2015-10-12 for ��ѡ������ʱ���˳�������
	var SelRowObj=document.getElementById('TabAuditFlagz'+iSeldRow);   //2011 12 31
	if (SelRowObj){}
	else
	{
		alert("��ѡ��һ����¼")
		return;
	}
	
	if (SelRowObj.innerText=="���") {
		alert("�������ɡA���������")
		return;
		}
	var SelRowObj=document.getElementById('TabAuditUserNamez'+iSeldRow);   //add 2012-01-12 
	if ((SelRowObj.innerText!=GuserName)){
		alert("�û�������������Ա��ˡA������ˡI")
		return;
		}
		
	Save_Click();  //������ʱ�Զ����� 2011 12 26

	
	var SelRowObj=document.getElementById('TabDemoz'+iSeldRow);
    var BZ=SelRowObj.value
   	var InString = "^"+AdmRowid+"^"+BillDr+"^"+""+"^"+""+"^"+""+"^"+""+"^"+""+"^"+0+"^"+0+"^"+0+"^"+0+"^"+Guser+"^"+GuserName+"^^^"+"���"+"^"+BZ+"^^^^^^^^^^^"
	var Ins=document.getElementById('ClassTxtUpdate');
	if (Ins) {var encmeth=Ins.value} else {var encmeth=''};
	var flag=cspRunServerMethod(encmeth,InString);
    if (flag>0)
    {
		alert("�ɹ�!")
	}
	else
	{
		alert("ʧ��!")
	}
	
	BtnFind_Click();
}
function Refuse_Click()
{
	/*var TabOEORIRowIdStr=GetSelectItem()
	var MedAudit=document.getElementById("MedAudit").value ;
    var ret=cspRunServerMethod(MedAudit,TabOEORIRowIdStr,"N",Guser);
    if (ret!=0)
    {
		alert("���±�־ʧ��!")
	}
    BtnFind_click()*/
	var SelRowObj=document.getElementById('TabDemoz'+iSeldRow);
    var BZ=SelRowObj.value
//Rowid^Adm_Dr^AdmInfo_Dr^OEORI_Dr^TaritmDr^PBD_Dr^InsuFlag^Scale^UnitPrice^Qty^Amount^AuditInfo^User_Dr^UserName^Date^Time^AuditFlag^BZ^Demo1^Demo2^Demo3^Demo4^Demo5^Demo6^Demo7^Demo8^Demo9^Demo10
	var InString = "^"+AdmRowid+"^"+""+"^"+""+"^"+""+"^"+""+"^"+""+"^"+""+"^"+0+"^"+0+"^"+0+"^"+0+"^"+Guser+"^"+GuserName+"^^^"+"�ܾ�"+"^"+BZ+"^^^^^^^^^^^"
	var Ins=document.getElementById('ClassTxtUpdate');
	if (Ins) {var encmeth=Ins.value} else {var encmeth=''};
	var flag=cspRunServerMethod(encmeth,InString);
    
    if (flag>0)
    {
		alert("�ɹ�!")
	}
	else
	{
		alert("ʧ��!")
	}
}
function Resume_Click()
{
	/*var TabOEORIRowIdStr=GetSelectItem()
	var MedAudit=document.getElementById("MedAudit").value ;
    var ret=cspRunServerMethod(MedAudit,TabOEORIRowIdStr,"",Guser);
    if (ret!=0)
    {
		alert("���±�־ʧ��!")
	}
    BtnFind_click()*/
    
    //add by zhangdongliang at 2015-10-12 for ��ѡ������ʱ���˳�������
	var SelRowObj=document.getElementById('TabAuditFlagz'+iSeldRow);   //2011 12 31
	if (SelRowObj){}
	else
	{
		alert("��ѡ��һ����¼")
		return;
	}
    
	var SelRowObj=document.getElementById('TabDemoz'+iSeldRow);
    var BZ=SelRowObj.value
//Rowid^Adm_Dr^AdmInfo_Dr^OEORI_Dr^TaritmDr^PBD_Dr^InsuFlag^Scale^UnitPrice^Qty^Amount^AuditInfo^User_Dr^UserName^Date^Time^AuditFlag^BZ^Demo1^Demo2^Demo3^Demo4^Demo5^Demo6^Demo7^Demo8^Demo9^Demo10
	var InString = "^"+AdmRowid+"^"+""+"^"+""+"^"+""+"^"+""+"^"+""+"^"+""+"^"+0+"^"+0+"^"+0+"^"+0+"^"+Guser+"^"+GuserName+"^^^"+"����"+"^"+BZ+"^^^^^^^^^^^"
	var Ins=document.getElementById('ClassTxtUpdate');
	if (Ins) {var encmeth=Ins.value} else {var encmeth=''};
	var flag=cspRunServerMethod(encmeth,InString);
    
    if (flag>0)
    {
		alert("�ɹ�!")
	}
	else
	{
		alert("ʧ��!")
	}    
}

function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tINSUAuditIP');
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	if (iSeldRow==selectrow){
		iSeldRow=0
		AdmRowid="";
		BillDr="";
		}
	else
	{
		iSeldRow=selectrow;
		var SelRowObj
		var obj
		SelRowObj=document.getElementById('TabAdmRowidz'+selectrow);
		if (SelRowObj){AdmRowid=SelRowObj.value;
			AdmDr=AdmRowid;   //add 2011 11 14
			}
		else{AdmRowid="";}
		//	alert(AdmRowid)
		SelRowObj=document.getElementById('TabBillDrz'+selectrow); //2011-10-20
		if (SelRowObj){BillDr=SelRowObj.innerText;}
		else{BillDr="";}
		SelRowObj=document.getElementById('TabAdmRowidz'+selectrow); //2012-01-10 ����ѡ���˺������ת�����Ӳ�������
		if (SelRowObj){EpisodeID=SelRowObj.value;}

		//var frm =dhcsys_getmenuform();
		//var frmEpisodeID=frm.EpisodeID;
				//alert(EpisodeID)
		//frmEpisodeID.value=EpisodeID;
		//add by zhangdongliang at 2014-05-05 for ��˿�ʼ���������ʾ��ϸ��Ϣ��
		var SelRowObj=document.getElementById('TabAuditFlagz'+iSeldRow);   //2011 12 31
		if (SelRowObj){AuditFlag=SelRowObj.innerText}
		if ((SelRowObj.innerText!=="��ʼ���")&&(SelRowObj.innerText!=="���")) {return;}
	}
	//alert(AdmRowid)
	
	var DivFlag=tkMakeServerCall("web.DHCINSUDivideSubCtl","GetDivSubUpConutByBillDr",BillDr,"");

	if (DivFlag>0){alert("�û����Ѿ�����ҽ�������ϴ������ܽ��з��õ�����");return;}
					
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=INSUAuditDetailsIP&AdmDr="+AdmRowid+"&BillDr="+BillDr;
	if (parent.frames['INSUAuditDetailsIP']) 
	{
		parent.frames['INSUAuditDetailsIP'].location.href=lnk;
	}
 	else
 	{
	 	var Ins=document.getElementById('GetAuditDetailIP');
		if (Ins) {var encmeth=Ins.value} else {var encmeth=''};
		var flag=cspRunServerMethod(encmeth,"",AdmRowid,BillDr);
 		//VerStr=tkMakeServerCall("web.INSUAuditIP","GetAuditDetailsIP",AdmRowid,BillDr);
 	}
}

function SelectAuditDic()
{
	var obj=document.getElementById('AuditDic');
	if(obj){var AuditDic=obj.value;}
	if(AdmRowid==""){return;}
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tINSUAuditIP');
	var rowObj=getRow(eSrc);
	SelRowObj=document.getElementById('TabDemoz'+iSeldRow);
	//if(SelRowObj){SelRowObj.value=AuditDic}
	if(SelRowObj){   //modify  2011 12 31 ��������ֵ�������д���
		if(SelRowObj.value!=""){
		SelRowObj.value=SelRowObj.value+","+AuditDic
		}
		else{
			SelRowObj.value=AuditDic
		}
	}
}
//add 2011 12 31 �����Ŀ��ϸ�ֵ䱸ע
function SelectAuditDicDetail()
{
	var obj=document.getElementById('AuditDicDetail');
	if(obj){var AuditDicDetail=obj.value;}
	if(AdmRowid==""){return;}
	var TObj=parent.frames["INSUAuditDetailsIP"];
	//var objtbl=TObj.document.getElementById('tINSUAuditDetailsIP');
	var selectrow=parent.frames["INSUAuditDetailsIP"].DetailsRow;
	var SelRowObj=TObj.document.getElementById('TDemoz'+selectrow);
	if(SelRowObj){   //modify  2011 12 31 ��������ֵ�������д���
		if(SelRowObj.value!=""){
		SelRowObj.value=SelRowObj.value+","+AuditDicDetail
		}
		else{
			SelRowObj.value=AuditDicDetail
		}
	}
}

function Save_Click()
{
	
	var SelRowObj=document.getElementById('TabAuditFlagz'+iSeldRow);   //2011 12 31
	if (SelRowObj){}
	else
	{
		alert("��ѡ��һ����¼")
		return;
	}
	//add by zhangdongliang at 2014-05-05 for ��˿�ʼ��������档
	var SelRowObj=document.getElementById('TabAuditFlagz'+iSeldRow);   //2011 12 31
	if (SelRowObj.innerText!=="��ʼ���") {
		alert("'��˱��' ���� '��ʼ���' ״̬,���ɱ���")
		return;
		}


	if(AdmRowid==""){
		alert("��ѡ��Ҫ��˵Ļ���!")
		return;
	}
	var SelRowObj=document.getElementById('TabAuditUserNamez'+iSeldRow);   //add 2012-01-12 
	if ((SelRowObj.innerText!=GuserName)) {
		alert("�û�������������Ա��ˡA���ɱ���I")
		return;
		}
	var TObj=parent.frames["INSUAuditDetailsIP"];
	var objtbl=TObj.document.getElementById('tINSUAuditDetailsIP');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var iCount;
	var SelRowObj;
	for(iCount= 1;iCount<=lastrowindex;iCount++) 
	{ 
		var Insuflag="",Price="",Qty="",Amount="",orderRowid="",TarDr="",InString="",BZ="";
		SelRowObj=TObj.document.getElementById('TInsuFlagz'+iCount);
		if(SelRowObj)
		{
			if (SelRowObj.checked==true){Insuflag="N";} //���ϱ�ʾ����Ϊ�Է�
			else {Insuflag="Y";}
			//�����ϵı�־��ʵû���õ���,��̨����ʱͨ��Global�еı�־���ж�
		}
		/*
		SelRowObj2=TObj.document.getElementById('TInsuFlag2z'+iCount);  //add hwq 2011-11-11
		if(SelRowObj2)
		{
			if (SelRowObj2.checked==true){Insuflag="Y";} //���ϱ�ʾ����Ϊҽ���ڡA�ָ�ԭ��
			else {Insuflag="N";}
			//�����ϵı�־��ʵû���õ���,��̨����ʱͨ��Global�еı�־���ж�
		}
		if ((SelRowObj.checked==true)&(SelRowObj2.checked==true)){
			alert("�Է���ҽ������ͬʱ��ѡ")
			return;
			}
			*/
		//if ((SelRowObj.checked==falsh)){Insuflag="Y";}
		SelRowObj=TObj.document.getElementById('TOEORIz'+iCount);
		if(SelRowObj){orderRowid=SelRowObj.value;}			
		SelRowObj=TObj.document.getElementById('TTarDrz'+iCount);
		if(SelRowObj){TarDr=SelRowObj.value;}
		SelRowObj=TObj.document.getElementById('TPricez'+iCount);
		if(SelRowObj){Price=SelRowObj.innerText;}
		SelRowObj=TObj.document.getElementById('TQtyz'+iCount);
		if(SelRowObj){Qty=SelRowObj.innerText;}
		SelRowObj=TObj.document.getElementById('TAmountz'+iCount);
		if(SelRowObj){Amount=SelRowObj.innerText;}
		
		//Lou 2011-08-24
		SelRowObj=TObj.document.getElementById('TDemoz'+iCount);
		if(SelRowObj){BZ=SelRowObj.value;}

		SelRowObj=TObj.document.getElementById('TListFlagz'+iCount);
		if(SelRowObj) //����ǻ�������Ҫѭ������orderRowid
		{
			if(SelRowObj.innerText=="��ϸ"){orderRowid="";}
		}
		orderRowid="" //���ϵͳû��ִ�м�¼��ȡ��ע�� Zhan 20160413
		//Rowid^Adm_Dr^PB_Dr^OEORI_Dr^TaritmDr^PBD_Dr^InsuFlag^Scale^UnitPrice^Qty^Amount^AuditInfo^User_Dr^UserName^Date^Time^AuditFlag^BZ^Demo1^Demo2^Demo3^Demo4^Demo5^Demo6^Demo7^Demo8^Demo9^Demo10
		InString = "^"+AdmRowid+"^"+BillDr+"^"+orderRowid+"^"+TarDr+"^"+""+"^"+Insuflag+"^"+""+"^"+Price+"^"+Qty+"^"+Amount+"^"+1+"^"+Guser+"^"+GuserName+"^^^^"+BZ+"^^^^^^^^^^^"
		var Ins=document.getElementById('ClassTxtUpdate');
		if (Ins) {var encmeth=Ins.value} else {var encmeth=''};
		var flag=cspRunServerMethod(encmeth,InString);
		if (flag>0){
		}
		else
		{
			alert("���ݱ���ʧ��!!");
			return;
		}
	}
	alert("���!")
}

function BtnFind_Click()
{
	var RegNo="",StartDate="", EndDate="", CheckAuditType="",DepList="",CheckInPat="",CheckAuditFlag="",ReceiveFlag=""
	var RegNo=document.getElementById('RegNo').value;
	var StartDate=document.getElementById('StartDate').value;
	var EndDate=document.getElementById('EndDate').value;
	var CheckAuditTypeobj=document.getElementById('CheckAuditType');
	if(CheckAuditTypeobj)
	{
		if (CheckAuditTypeobj.checked){var CheckAuditType="on";}
		else{var CheckAuditType="";}
	}
	
	var DepList='';
	var obj=document.getElementById('DepList');
	if(obj)
	{
		for (var i=0;i<obj.options.length;i++) 
		{				
			if (obj.options[i].selected==true) {
				if(DepList==""){DepList=obj.options[i].value;}
				else{DepList=DepList+'^'+obj.options[i].value;}
				
				}
		}
	}
	var obj=document.getElementById('CheckInPat');
	if(obj){CheckInPat=obj.value}
	//CheckInPat="1"  //һ������²����в�����˲���A�����ڴ�д��Ϊ1.��ͳҢ 2012-03-26
	var obj=document.getElementById('CheckAuditFlag'); //2011-10-20
	if(obj){CheckAuditFlag=obj.value}
	var obj=document.getElementById('ReceiveFlag'); //2011-11-21
	if(obj){ReceiveFlag=obj.value}
	var obj=document.getElementById('MediCare');  //add 012-01-09
	if(obj){MediCare=obj.value}
	if(iSeldRow!="") {var SelRowObj=document.getElementById('TabCheckFlagz'+iSeldRow);}
	if (SelRowObj&&SelRowObj.checked==true){
		if (MediCare==""){
			SelRowObj=document.getElementById('TMediCarez'+iSeldRow); 
			var obj=document.getElementById('MediCare');  
			if (SelRowObj&&obj){ 
				obj.value=SelRowObj.innerText;
				MediCare=obj.value
			}
		}
	}
	
	//alert(RegNo+"!"+CheckAuditType+"!"+CheckInPat+"!"+CheckAuditFlag)
    lnk="websys.default.csp?WEBSYS.TCOMPONENT=INSUAuditIP&RegNo="+RegNo+"&StartDate="+StartDate+"&EndDate="+EndDate+"&CheckAuditType="+CheckAuditType+"&DepList="+DepList+"&CheckInPat="+CheckInPat+"&CheckAuditFlag="+CheckAuditFlag+"&ReceiveFlag="+ReceiveFlag+"&MediCare="+MediCare;
    location.href=lnk;
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=INSUAuditDetailsIP&AdmDr="+""+"&BillDr="+"";
	if (parent.frames['INSUAuditDetailsIP']) 
	{
		parent.frames['INSUAuditDetailsIP'].location.href=lnk;
	}
	
}

function getpath()
{
	var getpath=document.getElementById('getpath');
	if (getpath) {var encmeth=getpath.value} else {var encmeth=''};
	path=cspRunServerMethod(encmeth)
}
function Print_Click() //���Ӵ�ӡ���� Lou 2011-10-22
{
	if(AdmRowid=="")
	{
		alert("����ѡ��һ������!")
		return;
	}
	var rtnStr=tkMakeServerCall("web.DHCINSUPort","GetInsuAuditFlag",BillDr);   //add hwq 2012-01 12
	if(rtnStr!="Y"){ //add hwq 2012-01-09
		alert("δ����ҽ����ˡA���ܵ���")
		return;
		}
	var xlApp,obook,osheet,xlsheet,xlBook,temp,str,vbdata,i,j 
    var Template
    Template=path+"INSU_AuditFeeList.xls"
    
    xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(Template);
	xlsheet = xlBook.ActiveSheet ; 
	var str=""
	SelRowObj=document.getElementById('TabRegNoz'+iSeldRow); //�ǼǺ�
	if (SelRowObj){str="�ǼǺ�:"+SelRowObj.innerText;}
	SelRowObj=document.getElementById('TabPatNamez'+iSeldRow);  //����
	if (SelRowObj){str=str+"  ����:"+SelRowObj.innerText;}
	SelRowObj=document.getElementById('TabSexz'+iSeldRow);  //�Ա�
	if (SelRowObj){str=str+"  �Ա�:"+SelRowObj.innerText;}
	SelRowObj=document.getElementById('TabCTDescz'+iSeldRow); //����
	if (SelRowObj){str=str+"  ����:"+SelRowObj.innerText;}
	xlsheet.Cells(3,1)=str
	SelRowObj=document.getElementById('TabAdmDatez'+iSeldRow); //��Ժ����
	if (SelRowObj){str="��Ժ����:"+SelRowObj.innerText;}
	SelRowObj=document.getElementById('TabDischgDatez'+iSeldRow);  //��Ժ����
	if (SelRowObj){str=str+"  ��Ժ����:"+SelRowObj.innerText;}
	SelRowObj=document.getElementById('TabTolAmountz'+iSeldRow);  //�ܽ��
	if (SelRowObj){str=str+"  �ܽ��:"+SelRowObj.innerText;}
	SelRowObj=document.getElementById('TabPointz'+iSeldRow); //�Էѱ���
	if (SelRowObj){str=str+"  �Էѱ�:"+SelRowObj.innerText;}
	xlsheet.Cells(4,1)=str
	SelRowObj=document.getElementById('TabDemoz'+iSeldRow); //��ע  2012-01-12
	if (SelRowObj){str="��ע:"+SelRowObj.value;} 
	xlsheet.Cells(5,1)=str
	SelRowObj=document.getElementById('TMediCarez'+iSeldRow); //������  add 2012-01-12 ���ڱ���ģ������ֻ�ȡ
	if (SelRowObj){ var Medicare=SelRowObj.innerText;}

	var GetDataNum=document.getElementById('GetDataNum');
	if (GetDataNum) {var encmeth=GetDataNum.value} else {var encmeth=''};
	var PayModeDataNum=cspRunServerMethod(encmeth,"")
	//var i
	for (i=1;i<=PayModeDataNum;i++)
	{
		var GetPayModeData=document.getElementById('GetDetailInfo');
		if (GetPayModeData) {var encmeth=GetPayModeData.value} else {var encmeth=''};
		var PayData=cspRunServerMethod(encmeth,i)
		var PayData=PayData.split("^")
		    DataLength=PayData.length;
		//for (j=1;j<=DataLength;j++)
		//{
		xlsheet.cells(7+i,1)=PayData[0];
		xlsheet.cells(7+i,2)=PayData[1];
		xlsheet.cells(7+i,3)=PayData[2];
		xlsheet.cells(7+i,4)=PayData[3];
		xlsheet.cells(7+i,5)=PayData[4];
		xlsheet.cells(7+i,6)=PayData[12];
		xlsheet.cells(7+i,7)=PayData[13];
		/*for (k=1;k<=7;k++)
		{
			xlsheet.Cells(6+i,k).Borders(9).LineStyle = 1;
			xlsheet.Cells(6+i,k).Borders(7).LineStyle = 1;
			xlsheet.Cells(6+i,k).Borders(10).LineStyle = 1;
			xlsheet.Cells(6+i,k).Borders(8).LineStyle = 1;
		}
		*/
		//}
	}
	//var TObj=parent.frames["INSUAuditDetailsIP"];
	//var objtbl=TObj.document.getElementById('tINSUAuditDetailsIP');
	//var SelRowObj;
	/*
	for(i=1;i<objtbl.rows.length;i++) 
	{ 
	
		xlsheet.cells(6+i,1)=objtbl.rows(i).cells(2).innerText;
		xlsheet.cells(6+i,2)=objtbl.rows(i).cells(3).innerText;
		xlsheet.cells(6+i,3)=objtbl.rows(i).cells(4).innerText;
		xlsheet.cells(6+i,4)=objtbl.rows(i).cells(5).innerText;
		xlsheet.cells(6+i,5)=objtbl.rows(i).cells(6).innerText;
		xlsheet.cells(6+i,6)=objtbl.rows(i).cells(12).innerText;
		xlsheet.cells(6+i,7)=objtbl.rows(i).cells(13).innerText;
	
		xlsheet.cells(6+i,1)=objtbl.rows(i).cells(1).innerText;
		xlsheet.cells(6+i,2)=objtbl.rows(i).cells(2).innerText;
		xlsheet.cells(6+i,3)=objtbl.rows(i).cells(3).innerText;
		xlsheet.cells(6+i,4)=objtbl.rows(i).cells(4).innerText;
		xlsheet.cells(6+i,5)=objtbl.rows(i).cells(5).innerText;
		xlsheet.cells(6+i,6)=objtbl.rows(i).cells(11).innerText;
		xlsheet.cells(6+i,7)=objtbl.rows(i).cells(13).innerText;
		for (j=1;j<=7;j++)
		{
			xlsheet.Cells(6+i,j).Borders(9).LineStyle = 1;
			xlsheet.Cells(6+i,j).Borders(7).LineStyle = 1;
			xlsheet.Cells(6+i,j).Borders(10).LineStyle = 1;
			xlsheet.Cells(6+i,j).Borders(8).LineStyle = 1;
		}
	}
	*/
	xlApp.Visible=true;
	//xlsheet.PrintPreview();
	xlsheet.SaveAs("D:\\"+Medicare+".xls");    //add hwq 2012-01-12	    
	xlBook.Close(savechanges=true);
	xlApp.Quit();
	xlApp=null;
	xlsheet=null;
	alert("�������")
}

function BtnStAudit_Click()
{
	var obj=document.getElementById("BtnStAudit"); //2011-10-28
	if(obj.disabled==true){return;}
	   
//Rowid^Adm_Dr^AdmInfo_Dr^OEORI_Dr^TaritmDr^PBD_Dr^InsuFlag^Scale^UnitPrice^Qty^Amount^AuditInfo^User_Dr^UserName^Date^Time^AuditFlag^BZ^Demo1^Demo2^Demo3^Demo4^Demo5^Demo6^Demo7^Demo8^Demo9^Demo10

	var SelRowObj=document.getElementById('TabDemoz'+iSeldRow);
    var BZ=SelRowObj.value
   	var InString = "^"+AdmRowid+"^"+BillDr+"^"+""+"^"+""+"^"+""+"^"+""+"^"+""+"^"+0+"^"+0+"^"+0+"^"+0+"^"+Guser+"^"+GuserName+"^^^"+"��ʼ���"+"^"+BZ+"^^^^^^^^^^^"
	var Ins=document.getElementById('ClassTxtUpdate');
	if (Ins) {var encmeth=Ins.value} else {var encmeth=''};
	var flag=cspRunServerMethod(encmeth,InString);
    if (flag>0)
    {
		alert("�ɹ�!")
	}
	else
	{
		alert("ʧ��!")
	}
	BtnFind_Click(); 
}
function CheckAuditFlag_Change()
{
	var obj=document.getElementById("CheckAuditFlag");
	if(obj){CheckAuditFlagValue=obj.value;}
	if(obj.value=="1") //�����ʱ,��˰�ť����
	{
		/*
		var obj=document.getElementById("BtnAudit");
		if(obj){ActBtn(obj);}
		var obj=document.getElementById("BtnStAudit");
		if(obj){AblBtn(obj);}
		*/
		CheckAuditFlagAbled();
	}
	BtnFind_Click(); //Lou 2011-11-10
	
}

//����ٻ�
function BtnAuditBack_Click()
{	
	var SelRowObj=document.getElementById('TabAuditUserNamez'+iSeldRow);   //add 2012-01-12 
	if ((SelRowObj.innerText!=GuserName)) {
		alert("�û�������������Ա��ˡA����������ˡI")
		return;
		}
	
	var obj=document.getElementById("BtnAudit"); //2011-10-28
	if(obj){
		if(obj.disabled==false){return;}

	  }
	  
	 //add by zhangdongliang at 2015-10-12 for ��ѡ������ʱ���˳�������
	var SelRowObj=document.getElementById('TabAuditFlagz'+iSeldRow);   //2011 12 31
	if (SelRowObj){}
	else
	{
		alert("��ѡ��һ����¼")
		return;
	}
//Rowid^Adm_Dr^AdmInfo_Dr^OEORI_Dr^TaritmDr^PBD_Dr^InsuFlag^Scale^UnitPrice^Qty^Amount^AuditInfo^User_Dr^UserName^Date^Time^AuditFlag^BZ^Demo1^Demo2^Demo3^Demo4^Demo5^Demo6^Demo7^Demo8^Demo9^Demo10

	var SelRowObj=document.getElementById('TabDemoz'+iSeldRow);
    var BZ=SelRowObj.value
    //var InString = "^"+AdmRowid+"^"+BillDr+"^"+""+"^"+""+"^"+""+"^"+""+"^"+""+"^"+0+"^"+0+"^"+0+"^"+0+"^"+Guser+"^"+GuserName+"^^^"+"���"+"^"+BZ+"^^^^^^^^^^^"
   	var InString = "^"+AdmRowid+"^"+BillDr+"^"+""+"^"+""+"^"+""+"^"+""+"^"+""+"^"+0+"^"+0+"^"+0+"^"+0+"^"+Guser+"^"+GuserName+"^^^"+"��ʼ���"+"^"+BZ+"^^^^^^^^^^^"
	var Ins=document.getElementById('ClassTxtUpdate');
	if (Ins) {var encmeth=Ins.value} else {var encmeth=''};
	var flag=cspRunServerMethod(encmeth,InString);
    
    if (flag>0)
    {
		alert("�ɹ�!")
	}
	else
	{
		alert("ʧ��!")
	}
	BtnFind_Click();
}

//��ӿ���ģ�� 2011 11 14  hwq
function AddDepInfo_Click()
{
	Guser=session['LOGON.USERID'];
	var DepList='';
	var obj=document.getElementById('DepList');
	if(obj)
	{
		for (var i=0;i<obj.options.length;i++) 
		{				
			if (obj.options[i].selected==true) {
				if(DepList==""){DepList=obj.options[i].value;}
				else{DepList=DepList+'^'+obj.options[i].value;}
				
				}
		}
	}
	var VerStr="";
	VerStr=tkMakeServerCall("web.INSUAuditIP","SaveDepInfo",Guser,DepList);
	if (VerStr==0){alert("�ɹ�")}
	else{alert("ʧ��")}
	
}


//���������Ͻ��ձ�־
function ReceiveInfo_Click(){
	if(AdmRowid==""){
		alert("��ѡ��Ҫ���յĻ���!")
		return;
	}
	var SelRowObj=document.getElementById('TabBillDrz'+iSeldRow);
    var BillNo=SelRowObj.value   //SelRowObj.innerText    
    var rtnStr=tkMakeServerCall("web.INSUAuditIP","SaveOutPutFlag",BillNo);
	if (rtnStr<0){alert("ʧ��")}
	else{alert("�ɹ�")}
	BtnFind_Click(); 
}
//סԺ���õ���  2011-12-30
function IPOutPut_Click(){
	if(BillDr==""){
		alert("��ѡ��Ҫ�����Ļ���!")
		return;
	}
	var rtnStr=tkMakeServerCall("web.DHCINSUPort","GetInsuAuditFlag",BillDr);
	if(rtnStr!="Y"){  //add hwq 2012-01-09
		alert("δ���в�����ˡA���ܵ���")
		return;
		}
	var rtn=IPRevOutPut(BillDr)
	if(rtn=="0"){
	 var rtn2=IPRevOutPutZD(BillDr)
	 if(rtn2=="0"){alert("�����ɹ�")}
	 else{"����ʧ��"}
	}
	else{alert("����ʧ��")}
}
function CheckInPat_Change()
{
	var obj=document.getElementById("CheckInPat");
	if(obj){CheckInPatValue=obj.value;}
	if((obj.value=="1")||(obj.value=="3")) // ��Ժ,�Ѳ������ 
	{
		var obj=document.getElementById("CheckAuditFlag"); 
		if (obj){obj.selectedIndex=3}		//ȫ��
	}
	if(obj.value=="2") // ��Ժδ����
	{
		var obj=document.getElementById("CheckAuditFlag"); 
		if (obj){obj.selectedIndex=0}		//ȫ��
	}
	
	BtnFind_Click(); //Lou 2011-11-10
	
}

function PapmiNo_onkeydown()
{	
	if (window.event.keyCode==13)
	{	
		var obj=document.getElementById("RegNo");    
		if (obj)
		{
			if (obj.value=="")
			{
				alert("�ǼǺŲ���Ϊ��");
				obj.focus();
				return false;
			}
		}
		var PapmiNoLength=10-obj.value.length;     //�ǼǺŲ���   	
		if (obj)
		{
			for (var i=0;i<PapmiNoLength;i++)
			{
				obj.value="0"+obj.value;			
			}
		}
		PapmiNo=obj.value;	
		//BtnFind_click();
		              
	}
}
/*
function NurAudit_Click()
{
	var PrescNoStr=GetSelectItem()
	var MedAudit=document.getElementById("MedNurAudit").value ;
    var ret=cspRunServerMethod(MedAudit,PrescNoStr,"Y");
    BtnFind_click()
}
function NurResume_Click()
{
	var PrescNoStr=GetSelectItem()
	var MedAudit=document.getElementById("MedNurAudit").value ;
    var ret=cspRunServerMethod(MedAudit,PrescNoStr,"");
    BtnFind_click()
}
function SendMsg_Click()
{
	var ward=document.getElementById("ward").value ;
    var SavMsg=document.getElementById("SavMsg").value ;
    var warddes=document.getElementById("warddes").value;
    var Process=document.getElementById("Processz"+1).innerText;
    var userid=session['LOGON.USERID'];
	var ret=cspRunServerMethod(SavMsg,ward,warddes,userid,Process);
	if (ret==0)    //WardId,Ward,UserId,Process
	alert("OK");
}

function RowChanged()
{
	alert("RowChanged")
	var eSrc=window.event.srcElement
	var rowObj=getRow(eSrc)
	
	var selectrow=rowObj.rowIndex
	var objtbl=document.getElementById('tINSUAudit');	
	var rows=objtbl.rows.length;

alert(rows)

var SelRowObj=document.getElementById('TabPrescNoz'+selectrow);	
var buyrowid=SelRowObj.innerText;
  
  if (rows>0)
  {
	var SelRowObj=document.getElementById('TabPrescNoz'+selectrow);	
	var PrescNo=SelRowObj.innerText;
  alert("PrescNo=" + PrescNo)
	  var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCNurInsAuditDetail&PrescNo="+PrescNo;	  
	
	  parent.frames['RPbottom'].document.location.href=lnk;
	}
	
}
function DHCWeb_GetRowIdx(wobj)
{
	try{
		var eSrc=wobj.event.srcElement;
		if (eSrc.tagName=="IMG") eSrc=wobj.event.srcElement.parentElement;
		var rowObj=getRow(eSrc);
		var selectrow=rowObj.rowIndex;
		return 	selectrow
	}catch (e)
	{
		alert(e.toString());
		return -1;
	}
}

function All_Click()
{
	var objUnPayFlage=document.getElementById("UnPayFlage");
	var objAllFlage=document.getElementById("AllFlage");
	if(objAllFlage){
		if(objAllFlage.checked==true){
			if(objUnPayFlage){objUnPayFlage.checked=false}
		}
	}

}
*/
//Zhan 20160525
//Disable the tutton;
function DisBtn(tgtobj){
	if (tgtobj){
		tgtobj.disabled=true;
		tgtobj.style.color="gray";
		//tgtobj.onclick=function() ��������δ���󣬰�ť��click�¼���Ҳ�޷����������� disabled��ֵ��
		//tgtobj.onclick=function(){return false;}
	}
}
//Enable the button
function ActBtn(tgtobj){
	if (tgtobj){
		tgtobj.disabled=false;
		tgtobj.style.color="blue";
		//tgtobj.onclick=function() ��������δ���󣬰�ť��click�¼���Ҳ�޷����������� disabled��ֵ��
		//tgtobj.onclick=function(){return true;}
	}
}

//add by zhangdongliang at 2017-02-28 for ��װCheckAuditFlag 
///�����",1 �����",2 �����",3 "ȫ��",""
function CheckAuditFlagAbled()
{
	//2011-10-28
	var objChAudit=document.getElementById("CheckAuditFlag"); //���״̬
	//alert(objChAudit.value)
	if(objChAudit.value=="1") //�����ʱ,��˰�ť����
	{
		var obj=document.getElementById("BtnStAudit");
		if(obj){ActBtn(obj)}
		var obj=document.getElementById("btnSave");  
		if(obj){DisBtn(obj)}
		var obj=document.getElementById("BtnAudit");
		if(obj){DisBtn(obj);}	//add by zhangdongliang at 2016-10-18 for�˴�BtnAuditӦ�ð�ť������
		var obj=document.getElementById("BtnAuditBack"); 
		if(obj){DisBtn(obj)}
		var obj=document.getElementById("BtnReceive"); 
		if(obj){DisBtn(obj)}
	
	}
	else if(objChAudit.value=="2") 
	{
		var obj=document.getElementById("BtnStAudit");
		if(obj){DisBtn(obj)}
		var obj=document.getElementById("btnSave");
		if(obj){ActBtn(obj)}
		var obj=document.getElementById("BtnAudit");
		if(obj){ActBtn(obj)}
		var obj=document.getElementById("BtnAuditBack"); 
		if(obj){DisBtn(obj)}
		var obj=document.getElementById("BtnReceive"); 
		if(obj){DisBtn(obj)}
	}
	else if(objChAudit.value=="3")
	{ 
		var obj=document.getElementById("BtnStAudit");
		if(obj){DisBtn(obj)}
		var obj=document.getElementById("btnSave");
		if(obj){DisBtn(obj)}	
		var obj=document.getElementById("BtnAudit");
		if(obj){DisBtn(obj)}
		var obj=document.getElementById("BtnAuditBack"); //���״̬���ٻؿ���
		if(obj){ActBtn(obj)}		
		var obj=document.getElementById("BtnReceive"); 
		if(obj){ActBtn(obj)}
	}
	else if(objChAudit.value=="")   //add hwq 2012-01-12
	{
		var obj=document.getElementById("BtnStAudit");
		if(obj){DisBtn(obj)}
		var obj=document.getElementById("btnSave");
		if(obj){DisBtn(obj)}	
		var obj=document.getElementById("BtnAudit");
		if(obj){DisBtn(obj)}
		var obj=document.getElementById("BtnAuditBack"); //���״̬���ٻؿ���
		if(obj){DisBtn(obj)}	
		var obj=document.getElementById("BtnReceive"); 
		if(obj){DisBtn(obj)}
		var obj=document.getElementById("BtnOutPut"); 
		//if(obj){DisBtn(obj);}
		var obj=document.getElementById("IPOutPut"); 
		if(obj){DisBtn(obj)}
	}
}	

document.body.onload = BodyLoadHandler;
