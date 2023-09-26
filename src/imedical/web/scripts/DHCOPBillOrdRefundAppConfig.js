///DHCOPBillOrdRefundAppConfig.js
var Guser
var SelectedRow="-1";
function BodyLoadHandler()
{
   var obj=document.getElementById("BtnInsert");
   if (obj){
      obj.onclick=Insert_Click;
   }
   var obj=document.getElementById("BtnUpdate");
   if (obj){
      obj.onclick=Update_Click;
   }
   var obj=document.getElementById("BtnClear");
   if (obj){
      obj.onclick=Clear_Click;
   }
   var obj=document.getElementById("Guser");
   Guser=obj.value	
}
function Insert_Click()
{
   var ORACRowidobj=document.getElementById("ORACRowid");	
   var ORACRowid=ORACRowidobj.value;
   if (ORACRowid==" "){ORACRowid=""}
   
   if (ORACRowid!=""){
      alert("�������ü�¼��������!!");
      return;
   } 
   var ArcicDescobj=document.getElementById("ArcicDesc");
   var ArcicDrobj=document.getElementById("ArcicDr");
   var ArcicDesc=ArcicDescobj.value
   if (ArcicDesc==" "){ArcicDesc=""}
   if (ArcicDesc==""){
	  ArcicDrobj.value="" 
      alert("ҽ�����಻��Ϊ��!!");
      return;
   }
   var ArcicDr=ArcicDrobj.value
   if (ArcicDr==" "){
      alert("ҽ�����಻��Ϊ��!!");
      return;
   }
   var ArcimDescobj=document.getElementById("ArcimDesc");
   var ArcimRowidobj=document.getElementById("ArcimRowid");
   var ArcimDesc=ArcimDescobj.value
   if (ArcimDesc==" "){ArcimDesc=""}
   if (ArcimDesc==""){
      ArcimRowidobj.value="";
   }
   var ArcimRowid=ArcimRowidobj.value;
   if (ArcimRowid==" "){ArcimRowid=""}
   var StDateobj=document.getElementById("StDate");
   var StDate=StDateobj.value;
   var EndDateobj=document.getElementById("EndDate");
   var EndDate=EndDateobj.value;
   var AppFlagobj=document.getElementById("AppFlag");
   var AppFlag=AppFlagobj.checked;
   if (AppFlag!=true){
      alert("��ѡ����Ч��־!!")
      return;
   } 
   if (Guser==" "){Guser=""}
   if (Guser==""){
      alert("����Ա����Ϊ��!!");
      return;
   }
   var InsertInfo=ArcicDr+"^"+ArcimRowid+"^Y"+StDate+"^"+EndDate
   
   var InsertOrdRefundAppConfig=document.getElementById('InsertOrdRefundAppConfig');
   if (InsertOrdRefundAppConfig) {var encmeth=InsertOrdRefundAppConfig.value} else {var encmeth=''};
   var RetCode=cspRunServerMethod(encmeth,InsertInfo,Guser,ORACRowid);
   
   if (RetCode=="InsertNull"){
      alert("¼����Ϣ����Ϊ��!!");
      return;    
   }else if (RetCode=="UserNull"){
      alert("����Ա����Ϊ��!!");
      return;     
      
   }else if (RetCode=="Already"){
      alert("¼����Ϣ�Ѿ����ڲ�������!!");
      return;     
      
   }else if (RetCode=="CatNull"){
      alert("ҽ�����಻��Ϊ��!!");
      return;     
      
   }else if (RetCode=="CatAlready"){
      alert("��ҽ�������Ѿ����ڲ�������!!");
      return;     
      
   }else if (RetCode=="OrdAlready"){
      alert("��ҽ���Ѿ����ڲ�������!!");
      return;     
      
   }else if (RetCode=="APPFlagErr"){
      alert("��ѡ����Ч��־!!");
      return;     
      
   }else if (RetCode=="0"){
      alert("����ɹ�!!");
      var Findobj=document.getElementById('Find');
      if (Findobj){Findobj.click();}     
      
   }else{
      alert("����ʧ��!!");
      return;
   }
   
}
function GetArcicRowid(value)
{
   if (value!=""){
      var tempstr=value.split("^");
      var obj=document.getElementById("ArcicDr");
      obj.value=tempstr[1];
   }   	
}
function GetArcimRowid(value)
{
   if (value!=""){
      var tempstr=value.split("^");
      var obj=document.getElementById("ArcimRowid");
      obj.value=tempstr[1];
      var obj=document.getElementById("ArcicDesc");
      obj.value=tempstr[2];
      var obj=document.getElementById("ArcicDr");
      obj.value=tempstr[3];
   }   	
}
function SelectRowHandler()	
{   
   var eSrc=window.event.srcElement;
   var rowobj=getRow(eSrc)
   Objtbl=document.getElementById('tDHCOPBillOrdRefundAppConfig');
   Rows=Objtbl.rows.length;
   var lastrowindex=Rows - 1;
   var rowObj=getRow(eSrc);
   var selectrow=rowObj.rowIndex;
   if (!selectrow) return;
   var ArcicDescobj=document.getElementById('ArcicDesc');
   var ArcicDrobj=document.getElementById('ArcicDr');
   var ArcimDescobj=document.getElementById('ArcimDesc');
   var ArcimRowidobj=document.getElementById('ArcimRowid');
   var StDateobj=document.getElementById('StDate');
   var EndDateobj=document.getElementById('EndDate');
   var AppFlagobj=document.getElementById('AppFlag');
   var ORACRowidobj=document.getElementById('ORACRowid');
   if (selectrow!=SelectedRow) {
      var SelRowObj=document.getElementById('TORACRowidz'+selectrow);
      var TORACRowid=SelRowObj.value;
      if (TORACRowid==" "){TORACRowid=""}
      var SelRowObj=document.getElementById('TArcicDescz'+selectrow);
      var TArcicDesc=SelRowObj.innerText;
      var SelRowObj=document.getElementById('TArcicDrz'+selectrow);
      var TArcicDr=SelRowObj.value;
      if (TArcicDesc==" "){TArcicDesc=""}
      if (TArcicDr==" "){TArcicDr=""}
      if ((TArcicDesc!="")&&(TArcicDr!="")&&(TORACRowid!="")){
         ArcicDescobj.value=TArcicDesc;
         ArcicDrobj.value=TArcicDr;
         ORACRowidobj.value=TORACRowid;
         var SelRowObj=document.getElementById('TArcimDescz'+selectrow);  
         var TArcimDesc=SelRowObj.innerText;
         var SelRowObj=document.getElementById('TArcimRowidz'+selectrow);  
         var TArcimRowid=SelRowObj.value;
         if (TArcimDesc==" "){TArcimDesc=""} 
         if (TArcimRowid==" "){TArcimRowid=""}
         if ((TArcimDesc!="")&&(TArcimRowid!="")){
	        ArcimDescobj.value=TArcimDesc; 
	        ArcimRowidobj.value=TArcimRowid;  
	     }          
         var SelRowObj=document.getElementById('TAPPFlagz'+selectrow);  
         var TAPPFlag=SelRowObj.value;
         if (TAPPFlag=="Y"){
	        AppFlagobj.checked=true;    
	     }else{
		    AppFlagobj.checked=false;    
		 }
		 var SelRowObj=document.getElementById('TStDatez'+selectrow);  
         var TStDate=SelRowObj.value; 
         if (TStDate!=""){
	        var TStDate1=TStDate.split("-");
	        var TStDate=TStDate1[2]+"/"+TStDate1[1]+"/"+TStDate1[0] 
            StDateobj.value=TStDate; 
         }
         var SelRowObj=document.getElementById('TEndDatez'+selectrow);  
         var TEndDate=SelRowObj.value; 
         if (TEndDate!=""){
	        var TEndDate1=TEndDate.split("-");
	        var TEndDate=TEndDate1[2]+"/"+TEndDate1[1]+"/"+TEndDate1[0] 
            EndDateobj.value=TEndDate; 
         }   
	  }
	 
	  SelectedRow = selectrow;
   }
   else{
      ArcicDescobj.value="";
      ArcicDrobj.value="";
      ArcimDescobj.value="";
      ArcimRowidobj.value="";
      StDateobj.value="";
      EndDateobj.value="";
      AppFlagobj.checked=false;
      ORACRowidobj.value="";
      SelectedRow="-1";
      
   }
   
}
function Update_Click()
{
   var ORACRowidobj=document.getElementById("ORACRowid");	
   var ORACRowid=ORACRowidobj.value;
   if (ORACRowid==" "){ORACRowid=""}
   
   if (ORACRowid==""){
      alert("��ѡ��Ҫ�޸ĵļ�¼!!");
      return;
   } 
   var ArcicDescobj=document.getElementById("ArcicDesc");
   var ArcicDrobj=document.getElementById("ArcicDr");
   var ArcicDesc=ArcicDescobj.value
   if (ArcicDesc==" "){ArcicDesc=""}
   if (ArcicDesc==""){
	  ArcicDrobj.value="" 
      alert("ҽ�����಻��Ϊ��!!");
      return;
   }
   var ArcicDr=ArcicDrobj.value
   if (ArcicDr==" "){
      alert("ҽ�����಻��Ϊ��!!");
      return;
   }
   var ArcimDescobj=document.getElementById("ArcimDesc");
   var ArcimRowidobj=document.getElementById("ArcimRowid");
   var ArcimDesc=ArcimDescobj.value
   if (ArcimDesc==" "){ArcimDesc=""}
   if (ArcimDesc==""){
      ArcimRowidobj.value="";
   }
   var ArcimRowid=ArcimRowidobj.value;
   if (ArcimRowid==" "){ArcimRowid=""}
   var StDateobj=document.getElementById("StDate");
   var StDate=StDateobj.value;
   var EndDateobj=document.getElementById("EndDate");
   var EndDate=EndDateobj.value;
   var AppFlagobj=document.getElementById("AppFlag");
   var AppFlag1=AppFlagobj.checked;
   var AppFlag="N";
   if (AppFlag1==true){
      AppFlag="Y"; 
   }else{
      AppFlag="N";
   } 
   if (Guser==" "){Guser=""}
   if (Guser==""){
      alert("����Ա����Ϊ��!!");
      return;
   }
   var UpdateInfo=ArcicDr+"^"+ArcimRowid+"^"+AppFlag + "^" + StDate+"^"+EndDate;
   
   var UpdateOrdRefundAppConfig=document.getElementById('UpdateOrdRefundAppConfig');
   if (UpdateOrdRefundAppConfig) {var encmeth=UpdateOrdRefundAppConfig.value} else {var encmeth=''};
   var RetCode=cspRunServerMethod(encmeth,UpdateInfo,Guser,ORACRowid);
   
   if (RetCode=="UpdateNull"){
      alert("¼����Ϣ����Ϊ��!!");
      return;    
   }else if (RetCode=="UserNull"){
      alert("����Ա����Ϊ��!!");
      return;     
      
   }else if (RetCode=="ORACNull"){
      alert("��ѡ��Ҫ�޸ĵļ�¼!!");
      return;     
      
   }else if (RetCode=="CatNull"){
      alert("ҽ�����಻��Ϊ��!!");
      return;     
      
   }else if (RetCode=="0"){
      alert("�޸ĳɹ�!!");
      var Findobj=document.getElementById('Find');
      if (Findobj){Findobj.click();}    
      
   }else{
      alert("�޸�ʧ��!!");
      return;
   }   	
}
function Clear_Click()
{
   var ArcicDescobj=document.getElementById('ArcicDesc');
   ArcicDescobj.value="";
   var ArcicDrobj=document.getElementById('ArcicDr');
   ArcicDrobj.value="";
   var ArcimDescobj=document.getElementById('ArcimDesc');
   ArcimDescobj.value="";
   var ArcimRowidobj=document.getElementById('ArcimRowid');
   ArcimRowidobj.value="";
   var StDateobj=document.getElementById('StDate');
   StDateobj.value="";
   var EndDateobj=document.getElementById('EndDate');
   EndDateobj.value="";
   var AppFlagobj=document.getElementById('AppFlag');
   AppFlagobj.checked=false;
   var ORACRowidobj=document.getElementById('ORACRowid');	
   ORACRowidobj.value="";
   var Findobj=document.getElementById('Find');
   if (Findobj){Findobj.click();}
}
document.body.onload = BodyLoadHandler;