var DiagDesc="",DiagCode="",xmmc="",xmbm="",xmlb="",HisDesc="",HisCode="",money="0"
var TabPatNo="",TabRptType="",TabAdmSeriNo="",TabDiagCode="",TabHisCode="",TabSDate="",TabRPTNo=""
var rowid,TabRptDate="",DicType="",CenterNo="",Amount=""
 var now=new Date()
Guser=session['LOGON.USERID'];
GuserName=session['LOGON.USERNAME'];
function BodyLoadHandler() {
	var obj=document.getElementById("RptType") //审批类别
	if (obj){
	  obj.size=1; 
	  obj.multiple=false;	  
	  obj.options[0]=new Option("门诊慢性病(职工)","15"); 
	  obj.options[1]=new Option("门诊特病","17"); 
	  obj.options[2]=new Option("转诊转院","26"); 
	  obj.options[3]=new Option("家庭病床","31"); 
	  obj.options[4]=new Option("特检特治","41"); 
	  obj.options[5]=new Option("特药","42"); 
	  obj.options[6]=new Option("城镇居民转院审批","82"); 
	  obj.options[7]=new Option("门诊慢性病(城镇居民)","83"); 
	  obj.options[8]=new Option("生育人员分娩定点审批","91"); 
	  obj.selectedIndex=0;
	 }
	//01 同意 02不同意
	var obj=document.getElementById("HosYJ") //医院意见
	if (obj){
	  obj.size=1; 
	  obj.multiple=false;	  
	  obj.options[0]=new Option("同意","01"); 
	  obj.options[1]=new Option("不同意","02"); 
	  obj.selectedIndex=0;
	}
	//01 同意 02不同意
	var obj=document.getElementById("KZRYJ") //科主任属意见
	if (obj){
	  obj.size=1; 
	  obj.multiple=false;	  
	  obj.options[0]=new Option("同意","01"); 
	  obj.options[1]=new Option("不同意","02"); 
	  obj.selectedIndex=0;
	}
	//01 同意 02不同意
	var obj=document.getElementById("JSYJ") //病人家属意见
	if (obj){
	  obj.size=1; 
	  obj.multiple=false;	  
	  obj.options[0]=new Option("同意","01"); 
	  obj.options[1]=new Option("不同意","02"); 
	  obj.selectedIndex=0;
	}
	//0-医院要求 1-	病人要求 2-	异地安置
	var obj=document.getElementById("OutType") //转外类别
	if (obj){
	  obj.size=1; 
	  obj.multiple=false;	  
	  obj.options[0]=new Option("医院要求","0"); 
	  obj.options[1]=new Option("病人要求","1"); 
	  obj.options[2]=new Option("异地安置","2"); 
	  obj.selectedIndex=0;
	}
	
	var obj=document.getElementById("ReadCard"); //读卡
	if (obj) obj.onclick=ReadCard_Click;
	//websys_setfocus('ReadCard');
	
	var obj=document.getElementById("OK"); //确认
	if (obj) obj.onclick=OK_Click;
	
	var obj=document.getElementById("Del"); //删除
	if (obj) obj.onclick=Del_Click;
	
	var obj=document.getElementById("FindSH"); //查询审核
	if (obj) obj.onclick=Query_Click;
	var obj=document.getElementById("tINSUReport"); //双击实现查询审批状态
	if (obj) obj.ondblclick=Query_Click;
	var obj=document.getElementById("qp"); //清屏
	if (obj) obj.onclick=qp_Click;
	
	var obj=document.getElementById("RptType"); //审批类别
	if (obj) obj.onchange=RptTypeonchange;
	try{
		var obj=document.getElementById("OutHosName");
		if (obj) (obj.style.background="00ffff")
		var obj=document.getElementById("xmmc");
		if (obj) (obj.style.background="00ffff")
		var obj=document.getElementById("sl");
		if (obj) (obj.style.background="00ffff")
		var obj=document.getElementById("DiagDesc");
		if (obj) (obj.style.background="00ffff")
	}catch(e){
	}
	
	var objRptlb=document.getElementById("Rptlb") //审批类别
	if (objRptlb){
	  objRptlb.size=1; 
	  objRptlb.multiple=false;	  
	  objRptlb.options[0]=new Option("门诊慢性病(职工)","15"); 
	  objRptlb.options[1]=new Option("门诊特病","17"); 
	  objRptlb.options[2]=new Option("转诊转院","26"); 
	  objRptlb.options[3]=new Option("家庭病床","31"); 
	  objRptlb.options[4]=new Option("特检特治","41"); 
	  objRptlb.options[5]=new Option("特药","42"); 
	  objRptlb.options[6]=new Option("城镇居民转院审批","82"); 
	  objRptlb.options[7]=new Option("门诊慢性病(城镇居民)","83"); 
	  objRptlb.options[8]=new Option("生育人员分娩定点审批","91"); 
	  objRptlb.selectedIndex=0;
	}
	var obj=document.getElementById("Find"); //查询审核
	if (obj) obj.onclick=Find_Click;
	
	var obj=document.getElementById("CardType"); //有无卡标志
	if (obj) obj.checked=true;
	var obj=document.getElementById("DicType");
	if (obj){obj.value="Skc516";}

	var obj=document.getElementById("DiagDesc");//实现回车操作
	if (obj) {obj.onkeydown=KeyDownDiagDesc; }
	var obj=document.getElementById("DiagCodeMXB");
	if (obj) {obj.onkeydown=KeyDownDiagCodeMXB; }
	var obj=document.getElementById("xmmc");
	if (obj) {obj.onkeydown=KeyDownxmmc; }
	var obj=document.getElementById("sl");
	if (obj) {obj.onkeydown=KeyDownsl; }
	var obj=document.getElementById("PatNo");
	if(obj){obj.onkeydown=ReadCard_Click;}

	var obj=document.getElementById("SDate"); //开始时间
	if (obj){ 
	var SDate=obj.value;
	var tmp = SDate.split("/");
	tmp[1]=parseFloat(tmp[1])+1
	if(parseInt(tmp[1])>12) {tmp[1]="01";tmp[2]=parseInt(tmp[2])+1}
	if((parseInt(tmp[0])==31)&&((parseInt(tmp[1])==2)||(parseInt(tmp[1])==4)||(parseInt(tmp[1])==6)||(parseInt(tmp[1])==9)||(parseInt(tmp[1])==11)))
  	{tmp[0]="01";tmp[1]=parseFloat(tmp[1])+1;}
  	if (String(tmp[1]).length<2) {tmp[1]="0"+tmp[1];}
  	var EDate=tmp[0]+"/"+tmp[1]+"/"+tmp[2]
	//var obj=document.getElementById("EDate"); //终止时间 ,默认一个月之后
	//if (obj) obj.value=EDate
	}
}
function qp_Click() //清屏
{
	location.reload();	
}
function ReadCard_Click()
{
	//location.reload();
	if (window.event.keyCode!=13) return
	var CardType="0",CardNo="",States=""
	var obj=document.getElementById("PatNo"); //个人编号
	if (obj) CardNo=obj.value;
	if ((String(CardNo).length==15)||(String(CardNo).length==18)) CardType="1"
	//var obj=document.getElementById("CardType"); //有无卡标志
	//if (obj.checked==true) CardType="0"; 
	//else CardType="1"
	//var str=ReadINSUCard(CardNo,Guser,CardType)
	var str=ReadCardNew(CardNo,CardType)
	//alert(str)
	var TmpData=str.split("|")
	if (TmpData[0]!="0") alert("读卡失败")
 	else 
 	{ ///9037786^10110377^3501-5^杨玉仙^女^^19360914000000^450106360914002^南宁市多丽电器有限责任公司^^^21^^786.51^^^^0^^450100|10015424^^20020515000000^2^1^^^^450107^10^100^3132      ^0^2011^840.8^0^0^0^0^0^0^0^46^1^0
	 	var TmpData1=TmpData[1].split("^")
	 	var obj=document.getElementById("PatNo"); //个人编号
		if (obj) obj.value=TmpData1[0];
		var obj=document.getElementById("CardNo"); //卡号
		if (obj) obj.value=TmpData1[1];
	 	var obj=document.getElementById("name"); //姓名
		if (obj) obj.value=TmpData1[3];
		var obj=document.getElementById("Sex"); //性别
		if (obj) obj.value=TmpData1[4];
		CenterNo=TmpData[2].split("^")[8]
		//alert(CenterNo)
		//if (TmpData[2].split("^")[8]=="450100")	States="南宁市"
		if (CenterNo=="450122")	States="武鸣县"
		else if (CenterNo=="450123")	States="隆安县"
		else if (CenterNo=="450124")	States="马山县"
		else if (CenterNo=="450125")	States="上林县"
		else if (CenterNo=="450126")	States="横县"  
		else if (CenterNo=="450127")	States="宾阳县"
		else States=""
	 	var obj=document.getElementById("States"); //参保人所属地
		if (obj) obj.value=States;
		//11 在职待遇 21	退休待遇 31	离休待遇 33	伤残军人待遇 91	成年居民 92	未成年居民
		if (TmpData1[11]=="11") TmpData1[11]="在职待遇"
		if (TmpData1[11]=="21") TmpData1[11]="退休待遇"
		if (TmpData1[11]=="31") TmpData1[11]="离休待遇"
		if (TmpData1[11]=="33") TmpData1[11]="伤残军人待遇"
		if (TmpData1[11]=="91") TmpData1[11]="成年居民"
		if (TmpData1[11]=="92") TmpData1[11]="未成年居民"
		var obj=document.getElementById("rylb"); //人员类别
		if (obj) obj.value=TmpData1[11];
		
	 	}
}
///个人编号 审批类别 住院流水号 转外就诊医院名称 医院等级 病种编码 病种名称 医院意见 项目编码
//项目名称 审批数量 医院审批日期 开始时间 终止时间 经办人 转外类别 备注 申请金额?特检特治疗为单价?
// 项目类别 审批编号 主要症状 目的 主治医师 科主任 病人家属意见 科主任属意见 录入员 录入时间 审批人 
// 医院本地项目编码 医院本地项目名称 医疗类别 审批批次号 参保人所属地
function OK_Click()
{
	var PatNo="",RptType="",AdmSeriNo="",OutHosName="",OutHosName="",HosLevel="";
	var HosYJ="",sl="",RptDate="",SDate="",EDate="",OutType="",Demo="";
	var RPTNo="",ZYZZ="",MD="",Doctor="",KZR="",KZRYJ="",LRuser="",LRDate="";
	var RPTUser="",AdmType="",NumberID="",States="";
	var ExpString="";
	
	var obj=document.getElementById("PatNo"); //个人编号
	if (obj) PatNo=obj.value;
	var obj=document.getElementById("RptType"); //审批类别
	if (obj) RptType=obj.value;
	var obj=document.getElementById("rylb"); //人员类别
	if(((obj.value=="成年居民")||(obj.value=="未成年居民"))&&(RptType=="15"))
	{
		 alert("人员类别和审批类别不一致!");
		 return;
	}
	if((obj.value!="成年居民")&&(obj.value!="未成年居民")&&(RptType=="83")) 
	{
		alert("人员类别和审批类别不一致!");
		return;
	}
	var obj=document.getElementById("AdmSeriNo"); //住院流水号
	if (obj) AdmSeriNo=obj.value;
	//var obj=document.getElementById("OutHosName"); //转外就诊医院名称
	//if (obj) OutHosName=obj.value;
	OutHosName="";
	var obj=document.getElementById("OutHosName"); //住院流水号
	if (obj) OutHosName=obj.value;
	HosLevel="";                              // 医院等级 1一级?2二级?3三级
	var obj=document.getElementById("HosYJ"); //医院意见
	if (obj) HosYJ=obj.value;
	var obj=document.getElementById("sl"); //审批数量
	if (obj) sl=obj.value;
	var obj=document.getElementById("money"); //审批金额
	if (obj) money=obj.value;
	var obj=document.getElementById("RptDate"); //医院审批日期
	if (obj) RptDate=DateTime(obj.value); //+"000000";
	var obj=document.getElementById("SDate"); //开始时间
	if (obj) SDate=DateTime(obj.value); ///+"000000";
	var obj=document.getElementById("SDate"); //终止时间 ,默认一个月之后
	if (obj) EDate=obj.value;
	

	var tmp = EDate.split("/");
	tmp[1]=parseFloat(tmp[1])+1;
	if(parseInt(tmp[1])>12){
		tmp[1]="01";
		tmp[2]=parseInt(tmp[2])+1;
	}
	if((parseInt(tmp[0])==31)&&((parseInt(tmp[1])==2)||(parseInt(tmp[1])==4)||(parseInt(tmp[1])==6)||(parseInt(tmp[1])==9)||(parseInt(tmp[1])==11))){
		tmp[0]="01";
		tmp[1]=parseFloat(tmp[1])+1;
	}
  	if (String(tmp[1]).length<2){
	  	tmp[1]="0"+tmp[1];
	}

  	var EDatestr=tmp[0]+"/"+tmp[1]+"/"+tmp[2];
	var obj=document.getElementById("EDate"); //终止时间 ,默认一个月之后
	if (obj) EDatestr=obj.value;
	EDate=DateTime(EDatestr);
	OutType="";  //"1" //转外类别	0-医院要求1-病人要求2-异地安置
	var obj=document.getElementById("Demo"); //备注
	if (obj) Demo=obj.value;
	if(money=="0"){
		var obj=document.getElementById("money"); //申请金额!特检特治疗为单价
		if (obj) {money=obj.value;}
	}

	if ((RptType=="41")&(xmlb=="")) alert("此项目类别为空,未对照!请先对照数据!");
	//xmlb="2" // ? 药品 2 ? 诊疗项目 3 ? 服务设施
	//RPTNo 审批编号 审批编号,通过?医院获取审批编号〔这个交易获取的审批编号	
    var obj=document.getElementById("ZYZZ"); //主要症状 ZYZZ
	if (obj) ZYZZ=obj.value;
	var obj=document.getElementById("MD"); //目的
	if (obj) MD=obj.value;
	var obj=document.getElementById("Doctor");//主治医师Doctor
	if (obj) Doctor=obj.value;
	var obj=document.getElementById("KZR");//科主任
	if (obj) KZR=obj.value;
	var obj=document.getElementById("JSYJ");//病人家属意见
	if (obj) JSYJ=obj.value;
	var obj=document.getElementById("KZRYJ");//科主任属意见
	if (obj) KZRYJ=obj.value;
	
	
	LRuser=GuserName;
	LRDate=RptDate;
	RPTUser=GuserName;
	
	NumberID=""; // 审批批次号

	States=CenterNo;
	
	var obj=document.getElementById("name");//病人姓名
	if (obj){
		var name=obj.value;
	}

	var str=PatNo+"|"+RptType+"|"+AdmSeriNo+"|"+OutHosName+"|"+HosLevel+"|"+DiagCode+"|"+DiagDesc+"|"+HosYJ+"|"+xmbm+"|"+xmmc+"|"+sl+"|"+RptDate+"|"+SDate+"|"+EDate+"|"+GuserName+"|"+OutType+"|"+Demo+"|"+money+"|"+xmlb+"|"+RPTNo+"|"+ZYZZ+"|"+MD+"|"+Doctor+"|"+KZR+"|"+JSYJ+"|"+KZRYJ+"|"+LRuser+"|"+LRDate+"|"+RPTUser+"|"+HisCode+"|"+HisDesc+"|"+AdmType+"|"+NumberID+"|"+States;
	ExpString=name+"|";

	

	var rtn=InsuReport(str,Guser,ExpString);
	if (rtn=="-1"){
		alert("审批上报失败!");
	} else{
		alert("审批上报成功!");	
	}
	
	if (RptType=="41"){
		websys_setfocus('xmmc');
		var obj=document.getElementById("xmmc")
		if (obj) obj.value="";
		var obj=document.getElementById("sl")
		if (obj) obj.value="1";
		var obj=document.getElementById("money")
		if (obj) obj.value="0";
		xmmc="",xmbm="",xmlb="",money="0"
		HisCode="",HisDesc="" ///,DiagCode="",DiagDesc=""
	}

}

function Del_Click()
{
	var PatNo="",RptType="",ExpString=""
	//alert("Del_Click")
	//var obj=document.getElementById("PatNo"); //个人编号
	//if (obj) PatNo=obj.value;
	//var obj=document.getElementById("RptType"); //审批类别
	//if (obj) RptType=obj.value;
	if (TabRptType=="门诊慢性病(职工)") TabRptType="15";           
	  if (TabRptType=="门诊特病") TabRptType="17";             
	  if (TabRptType=="转诊转院") TabRptType="26";             
	  if (TabRptType=="家庭病床") TabRptType="31";             
	  if (TabRptType=="特检特治") TabRptType="41";             
	  if (TabRptType=="特药") TabRptType="42";                 
	  if (TabRptType=="城镇居民转院审批") TabRptType="82";     
	  if (TabRptType=="门诊慢性病(城镇居民)") TabRptType="83"; 
	  if (TabRptType=="生育人员分娩定点审批") TabRptType="91";
	   
	var str=TabRptType+"|"+TabPatNo+"|"+TabAdmSeriNo+"|"+TabDiagCode+"|"+TabHisCode+"|"+TabSDate
	//alert(str)
	ExpString=rowid+"|"
	//调.NET
	 var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.INSU_GX_NNA");
	 var rtn=DHCINSUBLL.InsuReportDestroy(1,str,Guser,ExpString);	
    
    if (rtn=="-1") alert("审批上报撤销失败!")
    else alert("审批上报撤销成功!")
	//location.reload();
}
function Query_Click()
{
	var PatNo="",RptType="",ExpString=""
	//alert(TabRptType)
	//var obj=document.getElementById("PatNo"); //个人编号
	//if (obj) PatNo=obj.value;
	//var obj=document.getElementById("RptType"); //审批类别
	//if (obj) RptType=obj.value;
	if (TabRptType=="门诊慢性病(职工)") TabRptType="15";           
	  if (TabRptType=="门诊特病") TabRptType="17";             
	  if (TabRptType=="转诊转院") TabRptType="26";             
	  if (TabRptType=="家庭病床") TabRptType="31";             
	  if (TabRptType=="特检特治") TabRptType="41";             
	  if (TabRptType=="特药") TabRptType="42";                 
	  if (TabRptType=="城镇居民转院审批") TabRptType="82";     
	  if (TabRptType=="门诊慢性病(城镇居民)") TabRptType="83"; 
	  if (TabRptType=="生育人员分娩定点审批") TabRptType="91"; 

	var str=TabPatNo+"|"+TabRptType+"|"+"450113001"+"|"+""+"|"+""+"|"+""+"|"+TabRptDate+"|"+TabRPTNo
	//alert(str)
	ExpString=rowid+"|"
	var rtn;
	try{
		//调.NET
		//alert(ExpString)
		 var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.INSU_GX_NNA");
		rtn=DHCINSUBLL.InsuReportQuery(1,str,Guser,ExpString);	
	}catch(e){
		alert("调用医保接口发生异常,请检查医保环境是否正常安装!\n 错误描述:"+e.message);
		return "-1"
	}finally{
	} 
    if (rtn=="-1") alert("审批详细信息查询失败!")
    else if(rtn=="0") alert("未审批!")
    else if(rtn=="1") alert("审批通过!")
    else if(rtn=="2") alert("审批未通过!")
    else if(rtn=="3") alert("已使用!")
    
	location.reload();
}

function Find_Click()
{
 
 	var EndDate="",StartDate="",Type="",Edate=""
	//alert("Find_Click")
	var obj=document.getElementById("StartDate"); //审批开始时间
	if (obj) StartDate=obj.value;
	var obj=document.getElementById("EndDate"); //结束时间
	if (obj) EndDate=obj.value;
	var obj=document.getElementById("Rptlb"); //审批类别
	if (obj) Rptlb=obj.value;
	var obj=document.getElementById("Edate"); //审批类别
	if (obj) Edate=obj.value;
 	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=INSUReport&StartDate="+StartDate+"&EndDate="+EndDate+"&Rptlb="+Rptlb+"&Edate="+Edate;
	 location.href=lnk;
	 var obj=document.getElementById("StartDate"); //审批开始时间
	if (obj) obj.value=StartDate;
	var obj=document.getElementById("EndDate"); //结束时间
	if (obj) obj.value=EndDate;
	var obj=document.getElementById("Rptlb"); //审批类别
	if (obj) obj.value=Type;


}

function RptTypeonchange()  //审批类别改变时
{
	var obj=document.getElementById("OutHosName");
	if (obj) (obj.style.background="ffffff")//ffffff 白色
	var obj=document.getElementById("xmmc");
	if (obj) (obj.style.background="ffffff")
	var obj=document.getElementById("sl");
	if (obj) (obj.style.background="ffffff")
	var obj=document.getElementById("money");
	if (obj) (obj.style.background="ffffff")
	var obj=document.getElementById("DiagDesc");
	if (obj) (obj.style.background="ffffff")
	var obj=document.getElementById("DiagCodeMXB");
	if (obj) (obj.style.background="ffffff")
	
	var obj=document.getElementById("RptType");
	if (obj.value=="15") //门诊慢性病   
	{
		var obj=document.getElementById("OutHosName");
		if (obj) (obj.style.background="00ffff")
		var obj=document.getElementById("xmmc");
		if (obj) (obj.style.background="00ffff")
		var obj=document.getElementById("sl");
		if (obj) (obj.style.background="00ffff")
		var obj=document.getElementById("DiagDesc");
		if (obj) (obj.style.background="00ffff")
		var obj=document.getElementById("DicType");
	if (obj){obj.value="Skc516ZG";}
	}
	var obj=document.getElementById("RptType");
	if (obj.value=="83") //居民慢性病   
	{
		var obj=document.getElementById("OutHosName");
		if (obj) (obj.style.background="00ffff")
		var obj=document.getElementById("xmmc");
		if (obj) (obj.style.background="00ffff")
		var obj=document.getElementById("sl");
		if (obj) (obj.style.background="00ffff")
		var obj=document.getElementById("DiagDesc");
		if (obj) (obj.style.background="00ffff")
		var obj=document.getElementById("DicType");
	if (obj){obj.value="Skc516JM";}
	}
	if (obj.value=="41") //特检特治
	{
		var obj=document.getElementById("OutHosName");
		if (obj) (obj.style.background="00ffff")
		var obj=document.getElementById("money");
		if (obj) (obj.style.background="00ffff")
		var obj=document.getElementById("DiagCodeMXB");
		if (obj) (obj.style.background="00ffff")
	}
	if (obj.value=="17") //门诊特病
	{
		var obj=document.getElementById("OutHosName");
		if (obj) (obj.style.background="00ffff")
		var obj=document.getElementById("xmmc");
		if (obj) (obj.style.background="00ffff")
		var obj=document.getElementById("sl");
		if (obj) (obj.style.background="00ffff")
		var obj=document.getElementById("DiagCodeMXB");
		if (obj) (obj.style.background="00ffff")
	}
}

function SelectRowHandler()	{    //选中表格中一行,进行操作
	var eSrc=window.event.srcElement;
   var rowobj=getRow(eSrc)
   var Objtbl=document.getElementById('tINSUReport');
   var Rows=Objtbl.rows.length;
   var lastrowindex=Rows - 1;
   var rowObj=getRow(eSrc);
   var selectrow=rowObj.rowIndex;
 
  var Selobj=document.getElementById('TabPatNoz'+selectrow); 
  TabPatNo=Selobj.innerText;
	var Selobj=document.getElementById('TabRptTypez'+selectrow); 
  TabRptType=Selobj.innerText;
  var Selobj=document.getElementById('TabAdmSeriNoz'+selectrow); 
  TabAdmSeriNo="" //Selobj.innerText;
  var Selobj=document.getElementById('TabDiagCodez'+selectrow); 
  TabDiagCode=Selobj.innerText;
  var Selobj=document.getElementById('Tabxmbmz'+selectrow); 
  Tabxmbm=Selobj.innerText;
    var Selobj=document.getElementById('TabRPTNoz'+selectrow); 
  TabRPTNo=Selobj.innerText;
   var Selobj=document.getElementById('TabRptDatez'+selectrow); 
  TabRptDate=Selobj.innerText;
   var TmpDate=TabRptDate.split("-")
  TabRptDate=TmpDate[0]+TmpDate[1]+TmpDate[2]
  var Selobj=document.getElementById('TabSDatez'+selectrow); 
  TabSDate=Selobj.innerText 
  var TmpDate=TabSDate.split("-")
  TabSDate=TmpDate[0]+TmpDate[1]+TmpDate[2]
  var Selobj=document.getElementById('rowidz'+selectrow); 
  rowid=Selobj.value;
	         
}
function LookUpWithAlias(str) //病种名称
{  //alert(str)
	var tmp1 = str.split("^");
	var obj=document.getElementById("DiagDesc")
	if (obj) obj.value=tmp1[0];
   DiagCode=tmp1[2]
   DiagDesc=tmp1[0].split("|")[0]
   //alert(DiagDesc)
}
function LookUpDic(value) //慢性病病种名称
{  
	var tmp1 = value.split("^");
	var obj=document.getElementById("DiagCodeMXB")
	if (obj) obj.value=tmp1[0];
   DiagCode=tmp1[1]
   DiagDesc=tmp1[0]
}
function SetInsuString(value){	//项目名称 1505001 全血  
	var TarCate=value
	//alert(value)
	var TempData=TarCate.split("^")
	var obj=document.getElementById("xmmc")
	if (obj) obj.value=TempData[3];
	xmmc=TempData[11]
	xmbm=TempData[10]
	xmlb=TempData[17]
	money=TempData[7]
	HisCode=TempData[2]
	HisDesc=TempData[3]
	var obj=document.getElementById("money")
	if (obj) obj.value=TempData[7];
	}
function DateTime(str) //转化时间格式
{  
	var tmp = str.split("/");
	str=tmp[2]+tmp[1]+tmp[0]
	return str
}	
function KeyDownDiagDesc(){
	if (window.event.keyCode==13){
	window.event.keyCode=117;
	DiagDesc_lookuphandler();
	}
}
function KeyDownDiagCodeMXB(){
	if (window.event.keyCode==13){
	window.event.keyCode=117;
	DiagCodeMXB_lookuphandler();
	}
}
function KeyDownxmmc(){
	if (window.event.keyCode==13){
	window.event.keyCode=117;
	xmmc_lookuphandler();
	}
}
function KeyDownsl(){
	if (window.event.keyCode==13){
	var obj=document.getElementById("sl")
	if (obj) sl=obj.value;
	Amount=money*sl  ///单价*数量
	var obj=document.getElementById("money")
	if (obj) obj.value=Amount;
	}
}

document.body.onload = BodyLoadHandler;