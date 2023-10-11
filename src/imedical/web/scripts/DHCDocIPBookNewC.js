var DateFormat=tkMakeServerCall("websys.Conversions","DateFormat")
var PatPhoneFlag=""
var LocWardCheckBox="LocWard^LinkWard^AllWard"
document.body.onbeforeunload = DocumentUnloadHandler;
$(function(){
	//初始化加载Table模板
	LoadDataTable();	
});
function BodyLoadHandler(){
	//初始化Comb组件
	CombListCreat()
	
	//预约日期格式
	$('#InSdate').datebox('setValue',NowDate);
	//诊断选择
	$('#AdmDiadesc').keydown(LookupDiaDesc);
	//诊断图标选择
	$('#imgAdmDiadesc').click(LookDia);
	//去除诊断
	$('#DelDiangose').click(DelDiangose);
	//保存住院证
	$('#Save').click(SaveCon);
	//住院证打印
	$('#Print').click(Print);
	//日间手术申请
	$('#OpertionLink').click(OpenOpertionClick);
	
	//住院证查询
	$('#OrderListFind').click(OrderListFind);
	//就诊列表查询
	$('#AdmListFind').click(AdmListFind);
	//住院证保存并打印
	$('#SaPrint').click(SaPrint);
	//患者切换
	$('#CreatNew').click(CreatNew);
	//医嘱录入
	$('#OrderLink').click(OrderLinkClick);
	//联系电话修改
	$('#PatPhone').blur(PatPhoneOnblur);
	//本科室院区
	$('#LocWard').click(WardClick);
	//其他允许病区
	$('#LinkWard').click(WardClick);
	//无收治限制
	$('#AllWard').click(WardClick);
	
	//初始化查询
	//初始化患者信息	
	IntPaMes();
	//初始化就诊信息
	IntAmdMes();
	//初始化住院证信息
	IntBookMes();
	
	PatPhoneFlag=DHCC_GetElementData('PatPhone')
	
	window.setTimeout("Find()",10);

	
}
function OpenOpertionClick()
{
		OpenOpertion("Handel")
}

function PatPhoneOnblur()
{
	var PatPhone=DHCC_GetElementData("PatPhone");
	if(PatPhone!=PatPhoneFlag){
		if (PatPhone=="")
		{
			alert("联系电话不能为空");
			websys_setfocus(PatPhone);
			return false;
		}
		if (PatPhone.indexOf('-')>=0){
			var Phone=PatPhone.split("-")[0]
			var Phonearr=PatPhone.split("-")[1]
			if(Phone.length==3){
				if(Phonearr.length!=8){
				alert("固定电话长度错误,固定电话区号长度为【3】或【4】位,固定电话号码长度为【7】或【8】位,并以连接符【-】连接,请核实!")
				websys_setfocus(PatPhone);
	        	return false;
				}
			}else if(Phone.length==4){
				if(Phonearr.length!=7){
				alert("固定电话长度错误,固定电话区号长度为【3】或【4】位,固定电话号码长度为【7】或【8】位,并以连接符【-】连接,请核实!")
				websys_setfocus(PatPhone);
	        	return false;
				}
			}else{
				alert("不存在固定电话,请核实!")
				websys_setfocus(PatPhone);
	        	return false;
			}
			
		}else{
			if(PatPhone.length!=11){
				alert("联系电话电话长度应为【11】位,请核实!")
				websys_setfocus(PatPhone);
	        	return false;
			}
		}
	}
	
}
function Find()
{
	OrderListFind()
	AdmListFind()
	
}
///录入院前医嘱
function OrderLinkClick()
{
	if (BookIDMain==""){
		alert("缺少预约信息")
		return false
	}
	var url=tkMakeServerCall("web.DHCDocIPBookNew","GetOrderLink",BookIDMain)
	if (url==""){
		alert("非预住院状态不能开医嘱")
		return false
	}
	if(typeof websys_writeMWToken=='function') url=websys_writeMWToken(url);
	var winName="IPBookOrderWrite"; 
	var awidth=screen.availWidth/6*5; 
	var aheight=screen.availHeight/5*4; 
	var atop=(screen.availHeight - aheight)/2;
	var aleft=(screen.availWidth - awidth)/2;
	var param0="scrollbars=0,status=0,menubar=0,resizable=2,location=0"; 
	var params="top=" + atop + ",left=" + aleft + ",width=" + awidth + ",height=" + aheight + "," + param0 ;
	win=window.open(url,winName,params); 
	win.focus(); 	
}

///切换患者
function CreatNew()
{
	var url="websys.default.csp?WEBSYS.TCOMPONENT=DHCExamPatList"
	if(typeof websys_writeMWToken=='function') url=websys_writeMWToken(url);
	var winName="BookCreat"; 
	var awidth=screen.availWidth; 
	var aheight=screen.availHeight; 
	var atop=(screen.availHeight - aheight);
	var aleft=(screen.availWidth - awidth);
	var param0="scrollbars=0,status=0,menubar=0,resizable=2,location=0"; 
	var params="top=" + atop + ",left=" + aleft + ",width=" + awidth + ",height=" + aheight + "," + param0 ;
	win=window.open(url,winName,params); 
	win.focus(); 	
}

//切换患者回调函数
function ChangePerson(PAAdmNew){
	
	if (PAAdmNew!=""){
		ClearAll()
		EpisodeID=PAAdmNew
		BookIDMain=""
		//初始化患者信息
		IntPaMes();
		//初始化就诊信息
		IntAmdMes();
		//初始化住院证信息
		IntBookMes();
		//初始化查询
		OrderListFind()
		AdmListFind()
	}
	
	
}
function SaPrint(){
	if (Save()){
		Print()
	}
}

function Print()
{
	
	var MyPara=""
	var PDlime=String.fromCharCode(2);
	if (BookIDMain==""){
		$.messager.alert('警告','缺少预约信息,');
		return 
	}
	var encmeth=DHCC_GetElementData('GetPatBookMes')
	var BookMesag= cspRunServerMethod(encmeth,BookIDMain);
	if (BookMesag==""){
		$.messager.alert('警告','缺少预约信息,');
		return 
	}
	var BookMesagArry=BookMesag.split("^")
	var PatID=BookMesagArry[1]
	var encmeth=DHCC_GetElementData('GetPatDetail')
	var PatMes= cspRunServerMethod(encmeth,PatID);
	var PatMesArry=PatMes.split("^")
	
	//按照住院证初始化诊断信息
	var DiagnoseStr=BookMesagArry[36] ;
	var DiagnoseStrArry=DiagnoseStr.split(String.fromCharCode(2))
	var Legnt1=DiagnoseStrArry.length
	var DiaS=""
	for (var i=0;i<Legnt1;i++){
		var Desc=DiagnoseStrArry[i].split(String.fromCharCode(1))[0]
		var ID=DiagnoseStrArry[i].split(String.fromCharCode(1))[1]
		if ((ID=="")&&(Desc=="")){continue}
		if (DiaS==""){DiaS=Desc}
		else{DiaS=DiaS+","+Desc}
	
	}
	
	//姓名 性别 年龄 登记号 社会地位 工作单位 住址 联系电话 联系人 关系 联系人电话 诊断
	//住院科室 住院天数（不用） 首诊医院（不用） 操作用户姓名 操作日期 预约日期
	MyPara=MyPara+"PatName"+PDlime+PatMesArry[2]+"^"+"PatSex"+PDlime+PatMesArry[3]+"^"+"PatAge"+PDlime+PatMesArry[5];
	MyPara=MyPara+"^"+"PatRegNo"+PDlime+PatMesArry[1]+"^"+"PatStat"+PDlime+PatMesArry[19];
	MyPara=MyPara+"^"+"PatCom"+PDlime+PatMesArry[15]+"^"+"PatAdd"+PDlime+PatMesArry[17];
	MyPara=MyPara+"^"+"PatTel"+PDlime+PatMesArry[13];
	MyPara=MyPara+"^"+"PatContact"+PDlime+PatMesArry[20]+"^"+"PatRelation"+PDlime+PatMesArry[22];
	MyPara=MyPara+"^"+"PatReTel"+PDlime+PatMesArry[21]+"^"+"PatMR"+PDlime+DiaS;
	
	MyPara=MyPara+"^"+"PatInDep"+PDlime+BookMesagArry[30]+"^"+"PatInDays"+PDlime+"";
	MyPara=MyPara+"^"+"PatFirHos"+PDlime+""+"^"+"PatUserCode"+PDlime+session['LOGON.USERNAME'];
	MyPara=MyPara+"^"+"PatDocSign"+PDlime+"________"+"^"+"CreatDate"+PDlime+BookMesagArry[4];
	MyPara=MyPara+"^"+"BookDate"+PDlime+BookMesagArry[10];
	
	MyPara=MyPara+"^"+"Price"+PDlime+BookMesagArry[17];
	MyPara=MyPara+"^"+"StateIDDesc"+PDlime+BookMesagArry[25]; 
	MyPara=MyPara+"^"+"CreatUserDesc"+PDlime+BookMesagArry[26]; 
	MyPara=MyPara+"^"+"CreatDocIDDesc"+PDlime+BookMesagArry[27]; 
	MyPara=MyPara+"^"+"WardIdDesc"+PDlime+BookMesagArry[28]; 
	MyPara=MyPara+"^"+"BedDesc"+PDlime+BookMesagArry[29]; 
	MyPara=MyPara+"^"+"ICDDesc"+PDlime+BookMesagArry[31]; 
	MyPara=MyPara+"^"+"AdmInitStateDesc"+PDlime+BookMesagArry[32]; 
	MyPara=MyPara+"^"+"InReasnDesc"+PDlime+BookMesagArry[33]; 
	MyPara=MyPara+"^"+"InSourceDesc"+PDlime+BookMesagArry[34]; 
	MyPara=MyPara+"^"+"InBedTypeDesc"+PDlime+BookMesagArry[35]; 
	MyPara=MyPara+"^"+"ICDListStr"+PDlime+BookMesagArry[36]; 
	MyPara=MyPara+"^"+"UpdateUserDesc"+PDlime+BookMesagArry[37]; 
	MyPara=MyPara+"^"+"UpdateDate"+PDlime+BookMesagArry[38]; 
	MyPara=MyPara+"^"+"UpdateTime"+PDlime+BookMesagArry[39];
	MyPara=MyPara+"^"+"PatitnLevel"+PDlime+BookMesagArry[40]; 
	MyPara=MyPara+"^"+"CTLocMedUnit"+PDlime+BookMesagArry[41]; 
	MyPara=MyPara+"^"+"InDoctorDR"+PDlime+BookMesagArry[42]; 
	MyPara=MyPara+"^"+"TreatedPrinciple"+PDlime+BookMesagArry[43]; 
	MyPara=MyPara+"^"+"IPBookingNo"+PDlime+BookMesagArry[44]; 
	MyPara=MyPara+"^"+"PatitnLevelDesc"+PDlime+BookMesagArry[45]; 
	MyPara=MyPara+"^"+"CTLocMedUnitDesc"+PDlime+BookMesagArry[46]; 
	MyPara=MyPara+"^"+"InDoctorDesc"+PDlime+BookMesagArry[47]; 
	MyPara=MyPara+"^"+"TreatedPrincipleDesc"+PDlime+BookMesagArry[48]; 
	MyPara=MyPara+"^"+"HospDesc"+PDlime+BookMesagArry[49]; 
	MyPara=MyPara+"^"+"PatDate"+PDlime+BookMesagArry[50]; 
	
	var myobj=document.getElementById("ClsBillPrint");
	PrintFun(myobj,MyPara,"");
}

//查询就诊记录
function AdmListFind(){
	if (IPBKFlag=="Booking"){
		var AdmDateF=$('#AdmDateF').combobox('getValue') //预约日期
		var AdmDateN=$('#AdmDateN').combobox('getValue') //预约日期
		var queryParams = new Object();
		queryParams.ClassName ='web.DHCDocIPBookNew';
		queryParams.QueryName ='FindAdmList';
		queryParams.Arg1 =PatientID;
		queryParams.Arg2 =AdmDateF;
		queryParams.Arg3 =AdmDateN;
		queryParams.ArgCnt =3;
		var opts = AdmDataGrid.datagrid("options");
		opts.url = "./dhcdoc.cure.query.grid.easyui.csp"
		AdmDataGrid.datagrid('load', queryParams);
		AdmDataGrid.datagrid('unselectAll');
	}
	
}

///查询住院证列表
function OrderListFind()
{
	if (IPBKFlag=="Booking"){
		var FindBookDateF=$('#FindBookDateF').combobox('getValue') //预约日期
		var FindBookDateN=$('#FindBookDateN').combobox('getValue') //预约日期
		var queryParams = new Object();
		queryParams.ClassName ='web.DHCDocIPBookNew';
		queryParams.QueryName ='FindBookList';
		queryParams.Arg1 =PatientID;
		queryParams.Arg2 =FindBookDateF;
		queryParams.Arg3 =FindBookDateN;
		queryParams.ArgCnt =3;
		var opts = BookListDataGrid.datagrid("options");
		opts.url = "./dhcdoc.cure.query.grid.easyui.csp"
		BookListDataGrid.datagrid('load', queryParams);
		BookListDataGrid.datagrid('unselectAll');
		//console.log(PatientID+","+FindBookDateF+","+FindBookDateN)
	}
	
}

function SaveCon()
{
	var DoFlag="Y"
	if (BookIDMain!=""){
		var InCurStatu=$('#InCurStatu').combobox('getValue'); //住院证状态
		var encmeth=DHCC_GetElementData('GetPatBookMes')
		var BookMesag= cspRunServerMethod(encmeth,BookIDMain);
		if (BookMesag!=""){
			var BookMesagArry=BookMesag.split("^")
			var diastr=tkMakeServerCall("web.DHCDocIPBookNew","GetDHCDocIPBDictory",InCurStatu)
			var diastrArry=diastr.split("^")
			if ((BookMesagArry[8]!=InCurStatu)&&(("Register^SignBed").indexOf(BookMesagArry[53])>=0))
			{
				DoFlag="N"
				$.messager.confirm("确认","当前住院证状态为【"+BookMesagArry[25]+"】,将要更改为【"+diastrArry[1]+"】,是否继续保存？",function(r){
					if (r){
						Save()
					}
				})
				
			}
		}
	}
	if (DoFlag=="Y"){
		Save()
	}
}


//保存住院证
function Save()
{
	if (CanSave!="Y"){
		return
	}
	
	//保存前对就诊审核-目前允许多张住院证 返回-2不判断
	var Rtn=tkMakeServerCall("web.DHCDocIPBookNew","CheckBeforeSave",EpisodeID,BookIDMain,"1")
	if (Rtn!=0){
			var RtnArry=Rtn.split("^")
			if (RtnArry[0]=="-1"){
				$.messager.alert('警告',RtnArry[1]);
				return false
			}
	}
	
	var BookID=BookIDMain; //住院证ID
	var PatID=PatientID; //患者ID
	var PAAdmOP=EpisodeID; //就诊ID 门诊
	var PAAdmIP=EpisodeIDIP; //关联住院ID
	var CreateDate="" //创建日期
	var CreateTime="" //创建时间
	var CreaterUser=session['LOGON.USERID']
	var CreaterDocIDUser=session['LOGON.USERID']
	var InCurStatu=$('#InCurStatu').combobox('getValue'); //住院证状态
	var BookActive="Y" //住院证有效状态
	var InSdate=$('#InSdate').combobox('getValue') //预约日期
	var InWard=$('#InWard').combobox('getValue') //病区
	var InBed="" //$('#InBed').combobox('getValue') //床位
	var InCtloc=$('#InCtloc').combobox('getValue') //科室
	var ICDList=GetAllDia() //所有诊断ICD
	var InResumeText=$("#InResumeText").val().replace(/(^\s*)|(\s*$)/g,''); //备注
	var IPDeposit=$("#IPDeposit").val().replace(/(^\s*)|(\s*$)/g,''); //住院押金
	var AdmInitState=$("#AdmInitState").combobox('getValue'); //入院病情
	var InReason=$("#InReason").combobox('getValue'); //操作原因
	var InSorce=$("#InSorce").combobox('getValue'); //入院途径
	var InBedType=$("#InBedType").combobox('getValue'); //建议床位类型
	var MRCCondtion="" //紧急条件（韶关）-新版不用
	var ICDCode="" //ICD诊断-新版不用
	var CTLocMedUnit=$("#CTLocMedUnit").combobox('getValue') //医疗单元
	var InDoctor=$("#InDoctor").combobox('getValue') //主治医师
	var PatientLevel=$("#PatientLevel").combobox('getValue') //患者等级
	var TreatedPrinciple=$("#TreatedPrinciple").combobox('getValue') //收治原则
	var IsDayFlag="";
	var LocLogOn=session['LOGON.CTLOCID'];
	if($('#IsDayFlag').is(':checked')) {
	    IsDayFlag="Y";
	}
	var IsOutTriage="";
	if($('#IsOutTriage').is(':checked')) {
	    IsOutTriage="Y";
	}
	
	//-----------
	var Flag=$("#InCurStatu").combobox('getValue');
	if ((IPBKFlag!="Booking")){
		//非预约权限用户 BookID不能为空只能保存
		if (BookID==""){
			$.messager.alert('警告','住院证主索引不存在不能正常保存.');   
			return false
		}
	}
	
	
	//病区选择类型
	var WardFlag=WardSelectFind()
	
	//可操作的状态
	var CanDoStatu=GetCanDoBookCode()
	
	//组织信息
	var Instr=BookID+"^"+PatID+"^"+PAAdmOP+"^"+PAAdmIP+"^"+CreateDate+"^"+CreateTime+"^"+CreaterUser+"^"+CreaterDocIDUser
	var Instr=Instr+"^"+InCurStatu+"^"+BookActive+"^"+InSdate+"^"+InWard+"^"+InBed+"^"+InCtloc
	var Instr=Instr+"^"+ICDCode+"^"+InResumeText+"^"+""+"^"+IPDeposit+"^"+MRCCondtion
	//----------新版增加
	var Instr=Instr+"^"+AdmInitState+"^"+InReason+"^"+InSorce+"^"+InBedType+"^"+ICDList
	var Instr=Instr+"^"+CTLocMedUnit+"^"+InDoctor+"^"+PatientLevel+"^"+TreatedPrinciple
	var Instr=Instr+"^"+IsDayFlag+"^"+IsOutTriage+"^"+WardFlag+"^"+LocLogOn
	
	
	//保存前对单子审核
	var Rtn=tkMakeServerCall("web.DHCDocIPBookNew","CheckBeforeSave",PAAdmOP,BookID,"2",Instr,CanDoStatu)
	if (Rtn!=0){
			var RtnArry=Rtn.split("^")
			if (RtnArry[0]=="-1"){
				$.messager.alert('警告',RtnArry[1]);
				return false
			}
	}
	
	//保存
	var encmeth=DHCC_GetElementData('UpdateBook')
	var rtn=cspRunServerMethod(encmeth,Instr);
	if ((rtn=="-100")&&(rtn<0)){
		 $.messager.alert('警告','住院证保存失败',rtn);
		 return false;
	}else{
		 BookIDMain=rtn
		 var encmeth=DHCC_GetElementData('GetPatBookMes')
		 var BookMesag= cspRunServerMethod(encmeth,BookIDMain);
		 var Statu=BookMesag.split("^")[25]
		 if ((Statu=="撤销")&&(IPBKFlag=="Booking")){
			 BookIDMain=""
			 ClearBookMes()
		 }
		 $.messager.alert('提示','成功!'); 
		 var PatPhone=DHCC_GetElementData('PatPhone')
		 if(PatPhone!=PatPhoneFlag){
			var Rtn=tkMakeServerCall("web.DHCDocIPBookNew","SetPatPhoneByPatID",PatientID,PatPhone)
			if(Rtn!=0){
				alert("联系电话修改失败")
			}
		}
		   
	}
	//查询
	OrderListFind()
	AdmListFind()
	
	//保存后自动打开
	OpenOpertion("Auto")
	return true;
	
}

function GetAllDia(){
	//获取所有加载在界面上选中的诊断ICD
	var Str=""
	var ObjInputs=document.getElementsByName("ICDList")
    for(var i=0;i<ObjInputs.length;i++){
        var inputObj=ObjInputs[i];
        if ((inputObj)&&(inputObj.checked)){
	       var Desc=inputObj.getAttribute("DescICD")
	       var ICD=inputObj.id; //+String.fromCharCode(2)+Desc
	       if (ICD==""){
		       ICD=""+String.fromCharCode(2)+Desc;
		   }else{
			   ICD=ICD+String.fromCharCode(2)+"";
		   }
	       if (Str==""){Str=ICD}
	       else{Str=Str+"!"+ICD}
	    } 
    }
    return Str
}

function CombListCreat(){
	//病情
	AdmInitStateCombCreat()
	//当前状态
	InCurStatuCombCreat()
	//操作原因
	InReasonCombCreat()
	//入院途径
	InSorceCombCreat()
	//住院科室
	InCtlocCombCreat()
	//建议床位类型 
	InBedTypeCombCreat()
	//add by xz 病人等级
	PatientLevelCreat()
	//add by xz 收治原则
	TreatedPrincipleCreat()
	
	
}

//去除未选中的诊断
function DelDiangose()
{
	//去除列表中未选中的诊断
	var ObjInputs=document.getElementsByName("ICDList")
	var Str=""
    for(var i=0;i<ObjInputs.length;i++){
        var inputObj=ObjInputs[i];
        if ((inputObj)&&(inputObj.checked)){
	       var Desc=inputObj.getAttribute("DescICD")
	       var ICD=inputObj.id;
	       if (Str==""){Str=Desc+"^"+ICD}
	       else{Str=Str+"!"+Desc+"^"+ICD}
	    } 
    }
    if (Str==""){
	    $.messager.alert('警告','请注意您当前临床诊断被清除为空,请及时选择！');   
	}
    //重新赋值
	DianosListICD=Str
	IntDianosList()
	
}

///诊断---放大镜选择事件
function LookupDiaDesc(e){
try{
	var obj=websys_getSrcElement(e);
	var type=websys_getType(e);
	var key=websys_getKey(e);
	if ((type=='click')||((type=='keydown')&&(key==117))||((type=='keydown')&&(key==13))) {
		LookDia()
	}
   }catch(e){}

}

function LookDia(){
	//使用诊断录入统一接口
	var DiaType="0"
	var Desc=$("#AdmDiadesc").val().replace(/(^\s*)|(\s*$)/g,'')
	var Obj=document.getElementById("DiaType");
	if ((Obj)&&(Obj.checked)){
		DiaType="1"
	}
	var url='websys.lookup.csp';
	url += "?ID=MRDiagnos";
	url += "&CONTEXT=Kweb.DHCMRDiagnos:LookUpWithAlias";
	url += "&TLUJSF=DiaSelect";
	url += "&P1=" +Desc;
	url += "&P5=" +DiaType;
	websys_lu(url,1,'');
	return websys_cancel();	
}

//放大镜选择诊断之后处理
function DiaSelect(inStr)
{
	if (inStr!=""){
		var StrArry=inStr.split("^")
		var Desc=StrArry[0]
		var ID=StrArry[1]
		if (DianosListICD==""){DianosListICD=Desc+"^"+ID}
		else{DianosListICD=DianosListICD+"!"+Desc+"^"+ID}
		//选择之后直接创建到列表	
		IntDianosList()
	}
	DHCC_SetElementData("AdmDiadesc","")
	websys_setfocus("AdmDiadesc");
	
}

//住院科室Comb
function InCtlocCombCreat()
{
	$('#InCtloc').combobox({      
    	valueField:'CombValue',   
    	textField:'CombDesc',
    	url:"./dhcdoc.cure.query.combo.easyui.csp",
    	onBeforeLoad:function(param){
			param.ClassName = 'web.DHCDocIPBookNew';
			param.QueryName = 'CombListFind'
			param.Arg1="InCtloc"
			param.Arg2=session['LOGON.CTLOCID']
			param.Arg3=""
			param.Arg4=""
			param.ArgCnt =4;
		},
		onSelect: function(rec){
		   if ((rec)&&(rec.CombDesc.indexOf("-")>=0)&&(rec.CombDesc.split("-")[1]!="")) {
			   $('#InCtloc').combobox('setText', rec.CombDesc.split("-")[1]);
		   }
		   
		  diaplayWardCheck(rec.CombValue)
		   //$('#InCtloc').combobox('setValue',rec.CombValue);
		  //选择住院科室后初始化病区
          InWardCombCreat()
          //add by xz  选择住院科室后初始化医疗单元
          CTLocMedUnitCreat()
          //add by xz 选择住院科室后初始化住院医师
          InDoctorCreat()
        },
        onHidePanel:function(){
	       /*window.setTimeout(function (){
		       var CombDesc=$('#InCtloc').combobox('getText')
		       if ((CombDesc.indexOf("-"))&&(CombDesc.split("-")[1]!="")){
			       $('#InCtloc').combobox('setText', CombDesc.split("-")[1]);
		       }
	       },0)*/
	    },
		onChange:function(newValue,oldValue){
			if (newValue==""){
				$('#CTLocMedUnit').combobox('loadData', {});
				$('#CTLocMedUnit').combobox('setText', "");
				$('#CTLocMedUnit').combobox('setValue', "");

				$('#InDoctor').combobox('loadData', {});
				$('#InDoctor').combobox('setText', "");
				$('#InDoctor').combobox('setValue', "");
				
				$('#InWard').combobox('loadData', {});
				$('#InWard').combobox('setText', "");
				$('#InWard').combobox('setValue', "");
				
				
			}else if (newValue!=oldValue){
				 //选择住院科室后初始化病区
				InWardCombCreat()
				//add by xz  选择住院科室后初始化医疗单元
				CTLocMedUnitCreat()
				//add by xz 选择住院科室后初始化住院医师
				InDoctorCreat()
				
				InBedCombCreat()
			}
		},filter: function(q, row){
			var opts = $(this).combobox('options');
			return row[opts.textField].indexOf(q.toUpperCase()) >= 0;
	    }

	});	
}

//病区Comb初始化
function InWardCombCreat()
{
	
	var WardFlag=WardSelectFind()
	var Ctloc=$('#InCtloc').combobox('getValue');	
	$('#InWard').combobox({      
    	valueField:'CombValue',   
    	textField:'CombDesc',
    	url:"./dhcdoc.cure.query.combo.easyui.csp",
    	onBeforeLoad:function(param){
						param.ClassName = 'web.DHCDocIPBookNew';
						param.QueryName = 'CombListFind'
						param.Arg1="InWard"
						param.Arg2=Ctloc
						param.Arg3="" //默认数据
						param.Arg4=WardFlag
						param.ArgCnt =4;
		},
	  onLoadSuccess: function (data) {
	       //病区加载完毕之后加载对应的床位信息
	       InBedCombCreat()
	      //选择病区 预入院病区自动改变状态到预入院
	     var InWard=$('#InWard').combobox('getValue')
	    
	      //根据选择病区改变住院证状态
		 ChangeStatuByWard(InWard)
	       

        },
      onSelect: function(rec){
	    
	    //根据选择病区改变住院证状态
		ChangeStatuByWard(rec.CombValue)
			         
		 //选择住院科室后初始化床位
         InBedCombCreat()
        },filter: function(q, row){
			var opts = $(this).combobox('options');
			return row[opts.textField].indexOf(q.toUpperCase()) >= 0;
	    }
	});	
}
///add by xz 医疗单元初始化
function CTLocMedUnitCreat()
{
	//return false
	var Ctloc=$('#InCtloc').combobox('getValue');
	$('#CTLocMedUnit').combobox({      
    	valueField:'CombValue',   
    	textField:'CombDesc',
    	url:"./dhcdoc.cure.query.combo.easyui.csp",
    	onBeforeLoad:function(param){
						param.ClassName = 'web.DHCDocIPBookNew';
						param.QueryName = 'CombListFind'
						param.Arg1="CTLocMedUnit"
						param.Arg2=Ctloc
						param.Arg3="" //默认数据
						param.Arg4=""
						param.ArgCnt =4;
		},
	  onLoadSuccess: function (data) {
	       

        },
      onSelect: function(rec){
		  //选择医疗单元后初始化住院医师
          InDoctorCreat()
        },
	 onChange:function(newValue,oldValue){
		if (newValue==""){
			$('#InDoctor').combobox('loadData', {});
			$('#InDoctor').combobox('setText', "");
			$('#InDoctor').combobox('setValue', "");
			InDoctorCreat()
		}
		}
	});	
	}
///add by xz  住院医师初始化
function InDoctorCreat()
{
	var Ctloc=$('#InCtloc').combobox('getValue');
	var CTLocMedUnit=$('#CTLocMedUnit').combobox('getValue');
	$('#InDoctor').combobox({      
    	valueField:'CombValue',   
    	textField:'CombDesc',
    	url:"./dhcdoc.cure.query.combo.easyui.csp",
    	onBeforeLoad:function(param){
						param.ClassName = 'web.DHCDocIPBookNew';
						param.QueryName = 'CombListFind'
						param.Arg1="InDoctor"
						param.Arg2=Ctloc
						param.Arg3=CTLocMedUnit //默认数据
						param.Arg4=""
						param.ArgCnt =4;
		},
	  onLoadSuccess: function (data) {
	       

        },
      onSelect: function(rec){
		  
        }
	});	
	}
///床位Comb始化
function InBedCombCreat()
{
	var InWardDr=$('#InWard').combobox('getValue');
	$('#InBed').combobox({      
    	valueField:'CombValue',   
    	textField:'CombDesc',
    	url:"./dhcdoc.cure.query.combo.easyui.csp",
    	onBeforeLoad:function(param){
						param.ClassName = 'web.DHCDocIPBookNew';
						param.QueryName = 'CombListFind'
						param.Arg1="InBed"
						param.Arg2=InWardDr
						param.Arg3="" //默认数据
						param.Arg4=""
						param.ArgCnt =4;
		}
	});	
}

//操作原因Comb初始化
function InReasonCombCreat()
{
	//根据IPBKFlag标志设置默认显示值
	var CodeDefault=""
	var DisplayCode=""
	if (IPBKFlag=="Booking"){
		CodeDefault="Admit"
		DisplayCode="Admit"
	}else{
		CodeDefault="Admit"
	}
	DHCDocIPBDictoryCommon("InReason","IPBookingStateChangeReason",CodeDefault,DisplayCode)
}

//当前状态Comb初始化
function InCurStatuCombCreat()
{
	//根据IPBKFlag标志设置默认显示值
	var CodeDefault=""
	var DisplayCode=""
	if (IPBKFlag=="Booking"){
		CodeDefault="Booking"
		DisplayCode=BookStr
	}
	else{
		DisplayCode=OtherBookStr
	}
	DHCDocIPBDictoryCommon("InCurStatu","IPBookingState",CodeDefault,DisplayCode);
	if (LogonDoctorType != "DOCTOR") {
		$("#InCurStatu").combobox({disabled:true}); 
	}

}

//病情Comb初始化
function AdmInitStateCombCreat()
{
	$('#AdmInitState').combobox({      
    	valueField:'CombValue',   
    	textField:'CombDesc',
    	url:"./dhcdoc.cure.query.combo.easyui.csp",
    	onBeforeLoad:function(param){
						param.ClassName = 'web.DHCDocIPBookNew';
						param.QueryName = 'CombListFind'
						param.Arg1="AdmInitState"
						param.Arg2=""
						param.Arg3="" //默认数据
						param.Arg4=""
						param.ArgCnt =4;
		}
	});	
	//DHCDocIPBDictoryCommon("AdmInitState","IPBookingAdmInitState","Common","")
}

//建议床位类型初始化
function InBedTypeCombCreat()
{
	var CodeDefault="01"
	var DisplayCode=""
	DHCDocIPBDictoryCommon("InBedType","IPBookingBedType",CodeDefault,DisplayCode)
}

//入院途径初始化
function InSorceCombCreat()
{
	$('#InSorce').combobox({      
	valueField:'CombValue',   
	textField:'CombDesc',
	url:"./dhcdoc.cure.query.combo.easyui.csp",
	onBeforeLoad:function(param){
					param.ClassName = 'web.DHCDocIPBookNew';
					param.QueryName = 'CombListFind'
					param.Arg1="InSorce"
					param.Arg2=""
					param.Arg3="" //默认数据
					param.Arg4=""
					param.ArgCnt =4;
	}
	});	
}
///病人等级初始化
function PatientLevelCreat()
{
	var CodeDefault=""	
	var DisplayCode=""
	DHCDocIPBDictoryCommon("PatientLevel","IPBookingPatientLevel",CodeDefault,DisplayCode)
}
//收治原则初始化
function TreatedPrincipleCreat()
{
	var CodeDefault=""
	var DisplayCode=""
	DHCDocIPBDictoryCommon("TreatedPrinciple","IPBookingTreatedPrinciple",CodeDefault,DisplayCode)
	
	$('#TreatedPrinciple').combobox({
		onSelect: function(record){
			IsDayFlagClick(record.CombValue)
		}
	});

}

///创建字典Comb公共方法
///ListCombID 字典表类型Code 默认Code代码 显示Code代码
function DHCDocIPBDictoryCommon(ListName,CodeType,CodeDefault,DisplayCode)
{
	//alert(ListName+","+CodeType+","+CodeDefault+","+DisplayCode)
	$('#'+ListName+'').combobox({      
    	valueField:'CombValue',   
    	textField:'CombDesc',
    	url:"./dhcdoc.cure.query.combo.easyui.csp",
    	onBeforeLoad:function(param){
						param.ClassName = 'web.DHCDocIPBookNew';
						param.QueryName = 'CombListFind'
						param.Arg1="DHCDocIPBDictory"
						param.Arg2=CodeType
						param.Arg3=CodeDefault//默认数据
						param.Arg4=DisplayCode
						param.ArgCnt =4;
		}
	});	
}

//日期格式设置
function DateCahnge(date)
{
	var y = date.getFullYear();
	var m = date.getMonth()+1;
	var d = date.getDate();
	if (DateFormat==3){
		return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
	}else if(DateFormat==4){
		return (d<10?('0'+d):d)+"/"+(m<10?('0'+m):m)+"/"+y
	}
	//return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
	//return y+'-'+m+'-'+d;
}
function myparser(s){
	if (!s) return new Date();
	if (DateFormat==3){
		var ss = (s.split('-'));
		var y = parseInt(ss[0],10);
		var m = parseInt(ss[1],10);
		var d = parseInt(ss[2],10);
	}else if(DateFormat==4){
		var ss = (s.split('/'));
		var y = parseInt(ss[2],10);
		var m = parseInt(ss[1],10);
		var d = parseInt(ss[0],10);
	}
	if (!isNaN(y) && !isNaN(m) && !isNaN(d)){
	return new Date(y,m-1,d);
	}else{
	return new Date();
	}
}
function IntPaMes(){
	
	if (PatientID!=""){
		
		ClearPatMest()
		///患者ID^登记号^姓名^性别^年龄^身份证^国家^省^市^婚姻状况^民族^
		///手机^联系电话^文化程度^工作单位^^家庭地址^病案号^人员类型^
		///联系人姓名^联系人电话^联系人关系^联系人关系ID^患者级别^患者密级
		var encmeth=DHCC_GetElementData('GetPatDetail')
		var Patmes= cspRunServerMethod(encmeth,PatientID);
		var PatmesArry=Patmes.split("^");
		var PatID=PatmesArry[0]
		var PatNO=PatmesArry[1]
		var PatName=PatmesArry[2]
		var PatSex=PatmesArry[3]
		var PatBob=PatmesArry[4]
		var PatAge=PatmesArry[5]
		var PatGov=PatmesArry[6]
		var PatContry=PatmesArry[7]
		var PatProvince=PatmesArry[8]
		var PatCity=PatmesArry[9]
		var PatMarital=PatmesArry[10]
		var patNation=PatmesArry[11]
		var patPhone=PatmesArry[12]
		var patTel=PatmesArry[13]
		var patEducation=PatmesArry[14]
		var patWorkAddress=PatmesArry[15]
		var patCategoryDesc=PatmesArry[16]
		var patAddress=PatmesArry[17]
		var patMrNo=PatmesArry[18]
		var patSocial=PatmesArry[19]
		var patLinkName=PatmesArry[20]
		var patLinkPhone=PatmesArry[21]
		var patLinkRelation=PatmesArry[22]
		var patLinkRelationDr=PatmesArry[23]
		var patEmployeeFunction=PatmesArry[24]
		var patSecretLevel=PatmesArry[25]
		
		DHCC_SetElementData("PatNo",PatNO)
		DHCC_SetElementData("PatName",PatName)
		DHCC_SetElementData("PatSex",PatSex)
		DHCC_SetElementData("PatAge",PatAge)
		DHCC_SetElementData("PatMRNo",patMrNo)
		if (patTel!=""){DHCC_SetElementData("PatPhone",patTel)}else{DHCC_SetElementData("PatPhone",patPhone)}
		DHCC_SetElementData("PatType",patSocial)
		DHCC_SetElementData("PatID",PatGov)
		DHCC_SetElementData("PatFName",patLinkName)
		DHCC_SetElementData("PatFPhone",patLinkPhone)
		DHCC_SetElementData("PatFRelation",patLinkRelation)
		DHCC_SetElementData("PatCompany",patWorkAddress)
		DHCC_SetElementData("PatAddress",patAddress)
		
	}
		
}
//
function IntAmdMes(){
	//获取诊断ID
	if (EpisodeID!=""){
		//判断就诊是否可以用来办理住院证
		if (IPBKFlag=="Booking"){
			var Rtn=tkMakeServerCall("web.DHCDocIPBookNew","CheckBeforeSave",EpisodeID,"",1)
			if (Rtn!=0){
				var RtnArry=Rtn.split("^")
				if (RtnArry[0]=="-1"){
					$.messager.alert('警告',RtnArry[1]);
					CanSave="N"
					return
				}else{
					$.messager.alert('提示',RtnArry[1]);
				}
			}
		}
		var encmeth=DHCC_GetElementData('GetAdmICDList')
		var AdmICDList= cspRunServerMethod(encmeth,EpisodeID);
		DianosListICD=AdmICDList
		IntDianosList()
		var encmeth=DHCC_GetElementData('GetPatAdmMes')
		var PatAdmMes= cspRunServerMethod(encmeth,EpisodeID);
		if (PatAdmMes!=""){
			var PatAdmMesArry=PatAdmMes.split("^")
			if (PatAdmMesArry[5]!=PatientID){
				PatientID=PatAdmMesArry[5]
				IntPaMes()
			}
		}	
	}	
}

///诊断列表创建
function IntDianosList()
{
	//急性髓系白血病^452!朗格汉斯细胞肉瘤^514!内伤咳嗽Z^23029
	var Obj=document.getElementById("MRDiaList"); 
	Obj.innerHTML=""
	if (DianosListICD!=""){
		var DianosListArry=DianosListICD.split("!")
		for (var i=0;i<DianosListArry.length;i++){
			var Desc=DianosListArry[i].split("^")[0];
			var ICDDr=DianosListArry[i].split("^")[1];
			//if ((ICDDr=="")||(ICDDr=="undefined")) continue;
			if (ICDDr=="undefined") continue;
			var InnerStr="<input type=checkbox id=\""+ICDDr+"\" name=\""+"ICDList"+ "\" "+"\" DescICD=\""+Desc+ "\" "+ "value=1 checked"+" onclick=DelDiangose() ><span>"+Desc+"</span>"+"&nbsp&nbsp&nbsp"
			Obj.innerHTML=Obj.innerHTML+InnerStr
		}
	}
}

//初始化住院证信息如果住院证存在的话按照住院证上的信息为准从新对界面信息初始化
function IntBookMes(){	
	if (BookIDMain!=""){
		var encmeth=DHCC_GetElementData('GetPatBookMes')
		var BookMesag= cspRunServerMethod(encmeth,BookIDMain);
		if (BookMesag==""){
			return
		}
		var ArryBookMesag=BookMesag.split("^")
		//按照住院证信息初始化界面信息
		if (PatientID!=ArryBookMesag[1]){PatientID=ArryBookMesag[1];IntPaMes();}
		if (EpisodeID!=ArryBookMesag[2]){EpisodeID=ArryBookMesag[2];IntAmdMes();}
		
		//按照住院证初始化诊断信息
		var DiagnoseStr=ArryBookMesag[36] ;
		var DiagnoseStrArry=DiagnoseStr.split(String.fromCharCode(2))
		var Legnt1=DiagnoseStrArry.length
		var TemStr=""
		for (var i=0;i<Legnt1;i++){
			var Desc=DiagnoseStrArry[i].split(String.fromCharCode(1))[0]
			var ID=DiagnoseStrArry[i].split(String.fromCharCode(1))[1]
			if ((ID=="")&&(Desc=="")){continue}
			if (TemStr==""){TemStr=Desc+"^"+ID}
			else{TemStr=TemStr+"!"+Desc+"^"+ID}
			
		}
		DianosListICD=TemStr
		IntDianosList()
	
		//当前状态
		$('#InCurStatu').combobox('setValue',ArryBookMesag[8]);
		$('#InCurStatu').combobox('setText',ArryBookMesag[25])
		//入院病情
		$('#AdmInitState').combobox('setValue',ArryBookMesag[20]);
		//操作原因
		$('#InReason').combobox('setValue',ArryBookMesag[21]);
		//入院途径
		$("#InSorce").combobox('setValue',ArryBookMesag[22]);
		//预交金
		DHCC_SetElementData("IPDeposit",ArryBookMesag[17])
		//备注
		DHCC_SetElementData("InResumeText",ArryBookMesag[15])
		//建议床位类型
		$("#InBedType").combobox('setValue',ArryBookMesag[23]);
		//预约日期
		$('#InSdate').datebox('setValue',ArryBookMesag[10]);
		//科室--先设置科室在设置病区
		$("#InCtloc").combobox('select',ArryBookMesag[13]);
		var LocDesc=BookMesag.split("^")[30];
		if (LocDesc!=""){
			window.setTimeout("$('#InCtloc').combobox('setText','"+LocDesc+"')")
		}
		//设置病区选择区
		var WardType=ArryBookMesag[54];
		if (WardType>0){
			var LocWardCheckBoxArry=LocWardCheckBox.split("^")
			var WardTypeName=LocWardCheckBoxArry[WardType-1]
			if (WardTypeName!=""){
				$('#'+WardTypeName).attr("checked",true)
				MainWardClick(WardTypeName)
			}
		}
		
		//根据科室连动的项目在科室初始化或者change事件中进行初始化
		//InWardCombCreat() //初始化病区
		//CTLocMedUnitCreat()   //医疗单元初始化
		//InDoctorCreat()   //住院医师初始化
		
		//$("#InWard").combobox('setValue',ArryBookMesag[11]);
		
		window.setTimeout("$('#InWard').combobox('setValue','"+ArryBookMesag[11]+"')",500)
		//床位
		
		
		window.setTimeout("$('#InBed').combobox('setValue','"+ArryBookMesag[12]+"')",1000)
		
		
		$("#PatientLevel").combobox('select',ArryBookMesag[40]);
		$("#CTLocMedUnit").combobox('setValue',ArryBookMesag[41]);
	
		InDoctorCreat()   //住院医师初始化
		$("#InDoctor").combobox('select',ArryBookMesag[42]);
		$("#TreatedPrinciple").combobox('select',ArryBookMesag[43]);
		if(ArryBookMesag[51]=="Y"){
			$("#IsDayFlag").attr('checked',true);	
		}else{
			$("#IsDayFlag").attr('checked',false);		
		}
		
		if(ArryBookMesag[52]=="Y"){
			$("#IsOutTriage").attr('checked',true);	
		}else{
			$("#IsOutTriage").attr('checked',false);		
		}
		
	}
}

//清除所有
function ClearAll(){
	
	ClearBookMes()
	ClearPatMest()
	ClearAdmMes()	
}
//清除住院证信息
function ClearBookMes(){
	$("#InCtloc").combobox('setValue','');
	$('#InWard').combobox('loadData',{});
	$('#InBed').combobox('loadData', {});
	$('#AdmInitState').combobox('setValue','');
	$('#InReason').combobox('setValue','');
	$('#InSorce').combobox('setValue','');
	$("#InBedType").combobox('setValue','');
	$('#InSdate').datebox('setValue',NowDate);
	$('#CTLocMedUnit').combobox('loadData',{});
	$('#InDoctor').combobox('loadData',{});
	$('#TreatedPrinciple').combobox('setValue','');
	$('#PatientLevel').combobox('setValue','');
	$('#InBedType').combobox('setValue','');
	
	DHCC_SetElementData("IPDeposit",'')
	DHCC_SetElementData("InResumeText",'')	
}

//清除就诊诊断
function ClearAdmMes(){
	DianosListICD=""
	IntDianosList()
}
//清除患者基本信息
function ClearPatMest(){
	
	DHCC_SetElementData("PatNo",'')
	DHCC_SetElementData("PatName",'')
	DHCC_SetElementData("PatSex",'')
	DHCC_SetElementData("PatAge",'')
	DHCC_SetElementData("PatMRNo",'')
	DHCC_SetElementData("PatPhone",'')
	DHCC_SetElementData("PatType",'')
	DHCC_SetElementData("PatID",'')
	DHCC_SetElementData("PatFName",'')
	DHCC_SetElementData("PatFPhone",'')
	DHCC_SetElementData("PatFRelation",'')
	DHCC_SetElementData("PatCompany",'')
	DHCC_SetElementData("PatAddress",'')
}


function LoadDataTable()
{
	//住院证列表
	BookListDataGrid=$('#BookList').datagrid({  
		width : 'auto',
		border : true,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : true,
		url : '',
		queryParams : '',
		loadMsg : '加载中..',  
		pagination : true,  //
		rownumbers : true,  //
		idField:"BBookID",
		pageList : [10],
		//frozenColumns : FrozenCateColumns,
		columns :[[
					{field:'NO',title:'序号',width:50},
					{field:'IPBookingNo',title:'住院证号',width:80,align:'left'},
					{field:'BName',title:'姓名',width:70,align:'left'},
					{field:'BStatu',title:'状态',width:50,align:'left'},
        			{field:'BBDate',title:'预约日期',width:70},
					{field:'BBCTloc',title:'预约科室',width:100},   
        			{field:'BBWard',title:'预约病区',width:100},  
        			{field:'AdmInitStateDesc',title:'病情',width:60},    
        			
        			{field:'BBBed',title:'预约床位',width:100,hidden:true},
        			{field:'BBCreaterUser',title:'创建人',width:100},
        			{field:'BBCreaterDate',title:'创建日期',width:100},
        			{field:'rjss',title:'是否日间手术',width:100},
      
        			
        			{field:'BPatID',title:'患者ID',width:100,hidden:true},
        			{field:'BAmdID',title:'就诊ID',width:100,hidden:true},
        			{field:'BBookID',title:'住院证ID',width:100,hidden:true}  

    			 ]],
    		onSelect:function(rowid,RowData){
	    		//选择住院证获取对应信息
				if (SelectBookRow==rowid){
					SelectBookRow="-1"
					$(this).datagrid('unselectRow', rowid);
					BookIDMain=""
				}else{
					BookIDMain=RowData.BBookID
					//初始化住院证信息
					IntBookMes();
					SelectBookRow=rowid;
				}
			},
			onLoadSuccess:function (data) {
				//console.log(data);
			}
			
	});	
	
	//就诊列表--未开过住院证的就诊
	AdmDataGrid=$('#AdmList').datagrid({  
		width : 'auto',
		border : true,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : true,
		url : '',
		queryParams : '',
		loadMsg : '加载中..',  
		pagination : true,  //
		rownumbers : false,  //
		idField:"AdmID",
		pageList : [10],
		//frozenColumns : FrozenCateColumns,
		columns :[[
					{field:'NO',title:'序号',width:50},
					{field:'AdmDate',title:'就诊日期',width:100,align:'left'}, 
					{field:'AdmLoc',title:'就诊科室',width:100},
        			{field:'AdmMark',title:'就诊号别',width:100},
        			{field:'AdmDoc',title:'接诊医生',width:50},
        			{field:'AdmDias',title:'诊断',width:200},
        			{field:'AdmID',title:'AdmID',width:100,hidden:true},
        			
    			 ]],
    		onSelect:function(rowid,RowData){
	    		//选择住院证获取对应信息
				if (SelectAdmRow==rowid){
					SelectAdmRow="-1"
					$(this).datagrid('unselectRow', rowid);
					EpisodeID=""
					BookIDMain=""
				}else{
					BookIDMain=""
					EpisodeID=RowData.AdmID
					//初始化住院证信息
					SelectAdmRow=rowid;
					IntAmdMes()
				}
			}
   		
	});	
	
}

function PrintFun(PObj,inpara,inlist){
	////DHCPrtComm.js
	try{
		var mystr="";
		for (var i= 0; i<PrtAryData.length;i++){
			mystr=mystr + PrtAryData[i];
		}
		inpara=DHCP_TextEncoder(inpara)
		inlist=DHCP_TextEncoder(inlist)
		var docobj=new ActiveXObject("MSXML2.DOMDocument.4.0");
		docobj.async = false;    //close
		var rtn=docobj.loadXML(mystr);
		if ((rtn)){
			
			////ToPrintDoc(ByVal inputdata As String, ByVal ListData As String, InDoc As MSXML2.DOMDocument40)			
			var rtn=PObj.ToPrintDocNew(inpara,inlist,docobj);
			////var rtn=PObj.ToPrintDoc(myinstr,myList,docobj);
		}
	}catch(e){
		alert(e.message);
		return;
	}
}

function DocumentUnloadHandler(){
	if (IPBKFlag!="Booking"){
		if (window.opener)
		{
			window.opener.location.reload();  
		}
	}
}

function ChangeStatuByWard(WardDr){
	
	if (BookIDMain!=""){return}
	//选择病区 预入院病区自动改变状态到预入院
	var InpatWardFlag=tkMakeServerCall("web.DHCDocIPBookNew","GetWardPreInPatientFlag",WardDr)
	if (InpatWardFlag=="Y"){SetCurStatu("PreInPatient")}
	else{SetCurStatu("Booking")}
	
}

//按照病区串得位置获取当前选中得病区类型
function WardSelectFind()
{
	var WardFlag=""
	var CheckMutuallyArry=LocWardCheckBox.split("^")
	for (var i=0;i<CheckMutuallyArry.length;i++)
	{
		if (($("#"+CheckMutuallyArry[i]).is(':checked'))&(!$("#"+CheckMutuallyArry[i]).is(':hidden'))){WardFlag=(i+1)}
	}
	return WardFlag
}

function diaplayWardCheck(inlocdr){
	//控制选中后显示CheckBox
	if (inlocdr!=""){
		//关联得其他病区
		var LinkWard=tkMakeServerCall("web.DHCDocIPBookNew","GetLinkWard",inlocdr)
		if (LinkWard==""){if($('#LinkWard').length>0){$('#LinkWard').hide();$('#cLinkWard').hide();$('#LinkWard').attr("checked",false)}}
		else{if($('#LinkWard').length>0){$('#LinkWard').show();$('#cLinkWard').show()}}
		//无限制标识
		var LocCureLimit=tkMakeServerCall("web.DHCDocIPBookNew","GetLocCureLimit",inlocdr)
		if (LocCureLimit!="Y"){if($('#AllWard').length>0){$('#AllWard').hide();$('#cAllWard').hide();;$('#AllWard').attr("checked",false)}}
		else{if($('#AllWard').length>0){$('#AllWard').show();$('#cAllWard').show()}}
		
		//未找到选中得默认选中第一个
		var WardFlag=WardSelectFind()
		if (WardFlag==""){
			$('#LocWard').attr("checked",true)
		}
	}
}
//病区类型选中
function WardClick(){
	var Obj=GetEventElementObj()
	MainWardClick(Obj.name)
}

function MainWardClick(wartype){
	var CheckMutuallyArry=LocWardCheckBox.split("^")
	for (var i=0;i<CheckMutuallyArry.length;i++)
	{
		if (wartype!=CheckMutuallyArry[i]){if($("#"+CheckMutuallyArry[i]).length>0){$('#'+CheckMutuallyArry[i]).attr("checked",false)}}
	}
	
	//未找到选中得默认选中第一个
	var WardFlag=WardSelectFind()
	if (WardFlag==""){
		$('#'+CheckMutuallyArry[0]).attr("checked",true)
	}
	
	//通过病区类型初始化病区
	InWardCombCreat()

	//初始化床位信息
	InBedCombCreat()	
}


///获取响应事件的对象
function GetEventElementObj(){
	var isIE=document.all ? true : false;  
	var obj = null;  
	if(isIE==true){  
		obj = document.elementFromPoint(event.clientX,event.clientY);  
	}else{  
		e = arguments.callee.caller.arguments[0] || window.event;   
		obj = document.elementFromPoint(e.clientX,e.clientY);  
	}
	return obj
}

//日间手术点击
function IsDayFlagClick(TreatedPrinciplevalue)
{
	if (TreatedPrinciplevalue==""){return}
	var diastr=tkMakeServerCall("web.DHCDocIPBookNew","GetDHCDocIPBDictory",TreatedPrinciplevalue)
	var diaarry=diastr.split("^")
	if(diaarry[0]=="DaySurg"){
		var findstatu="N"
		var dataobj=$('#InCurStatu').combobox('getData');
	 	var datalength=dataobj.length;
	 	for (var i=0;i<datalength;i++){
			var statudr=dataobj[i].CombValue;
			if (statudr==""){continue}
			var statustr=tkMakeServerCall("web.DHCDocIPBookNew","GetDHCDocIPBDictory",statudr)
			var statustrarry=statustr.split("^")
			if (statustrarry[0]=="PreInPatient"){
					findstatu="Y"
			}
		}
		if (findstatu=="N"){
				$.messager.alert('提示',"预住院状态不可用!");	
		}
		SetCurStatu("PreInPatient")
	}else{
		//SetCurStatu("Booking")
	}

	
}

function SetCurStatu(CurStatuCode)
{
		var dataobj=$('#InCurStatu').combobox('getData');
	 	var datalength=dataobj.length;
	 	for (var i=0;i<datalength;i++){
			var statudr=dataobj[i].CombValue;
			if (statudr==""){continue}
			var statustr=tkMakeServerCall("web.DHCDocIPBookNew","GetDHCDocIPBDictory",statudr)
			var statustrarry=statustr.split("^")
			if (statustrarry[0]==CurStatuCode){
				$('#InCurStatu').combobox('setValue',statudr);
			}
		}
	
}



//打开日间手术ID
function OpenOpertion(OpeType)
{
	var Url=""
	var rtn=tkMakeServerCall("web.DHCDocIPBookNew","HavveActiveOpertion",BookIDMain)
	var rtnArry=rtn.split("^")
	var rtnflag=rtnArry[0]
	if ((rtnflag==0)||(rtnflag==1)){
		if (OpeType=="Auto"){
			//自动模式下只有未申请的单子才打开
			if (rtnflag==0){Url=tkMakeServerCall("web.DHCDocIPBookNew","GetBookOpertion",BookIDMain)}
		}else{
			Url=tkMakeServerCall("web.DHCDocIPBookNew","GetBookOpertion",BookIDMain)
		}
	}else{
		//不符合条件的单子自动模式下不提示
		if (OpeType=="Auto"){return}
		$.messager.alert('提示',"不能进行手术申请:"+rtnArry[1]);	
		return
		
	}
	if(typeof websys_writeMWToken=='function') url=websys_writeMWToken(url);
	//日间手术申请固定宽度
	var winName="OpenOpertion"; 
	var awidth=1260 //screen.availWidth/6*5; 
	var aheight=680 ;screen.availHeight/5*4; 
	var atop=(screen.availHeight - aheight)/2;
	var aleft=(screen.availWidth - awidth)/2;
	var param0="scrollbars=0,status=0,menubar=0,resizable=2,location=0"; 
	var params="top=" + atop + ",left=" + aleft + ",width=" + awidth + ",height=" + aheight + "," + param0 ;
	win=window.open(Url,winName,params); 
	win.focus();
	
}

function GetCanDoBookCode(){
	//可操作的状态
	var CanDoStatu=""
	if (IPBKFlag=="Booking"){
		CanDoStatu=BookStr
	}
	else{
		CanDoStatu=OtherBookStr
	}
	return 	CanDoStatu
}


