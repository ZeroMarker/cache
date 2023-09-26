///医保院外报销用
/// INSUOutOfHospitPay.js

var Guser=session['LOGON.USERID'];
var INSUTypeObj;
var INSUType="";

function BodyLoadHandler() {
    //初始化界面
    //iniForm(); tangzf 2019-9-3 --
	
    //清屏
    var obj = document.getElementById("ClearPage");
    if (obj) { obj.onclick = ClearPage_onclick; }
	/*
	//就诊类型
	var obj=document.getElementById("Zstr12")
	if (obj){obj.onchange=AdmType_onchange;}
	*/ // tangzf 2019-9-3
    //待遇类别
    //var obj=document.getElementById("Zstr10")
    //if (obj){obj.onchange=PatType_onchange;}
	
    //垫付
    var obj = document.getElementById("SaveINSUPay");
    if (obj) { obj.onclick = SaveINSUPay_onclick; }
	
    //作废
    var obj = document.getElementById("DivideStrike")
    if (obj) { obj.onclick = DivideStrike_onclick; }
	
    //垫付(回车事件)
    var obj = document.getElementById("jjzfe0")
    if (obj) {
        $("#jjzfe0").on('input', function (e) {
            Jjzfe0_onkeydown();
        });
    }
	
    //单据号(回车事件)
    var obj = document.getElementById("djlsh0")
    if (obj) {
        obj.onkeydown = Djlsh0_onkeydown;
    }
	
    //医保类型
	/*var obj=document.getElementById("Zstr04")
	if (obj){obj.onchange=TariType_onchange;}
	*/ // tangzf 2019-9-3 
    init_Layout();
}


//*******************************
//1:初始化界面                    *
//*******************************
function iniForm(){
	//医保统筹区
	var VerStrArea="";
	var newDicType="YAB003"+INSUType;
	var VerStrArea=tkMakeServerCall("web.INSUDicDataCom","GetSys","","",newDicType);
	//if ((VerStrArea=="")||(VerStrArea=="0")) {DHCWeb_HISUIalert("请在医保字典中维护 [YAB003]医保统筹区");return;}
	if (VerStrArea=="") {DHCWeb_HISUIalert("请在医保字典中维护 [YAB003]医保统筹区");return;}
	var Arr1Area=VerStrArea.split("!")
	//DHCWeb_HISUIalert(Arr1Area)
	obj=document.getElementById("Zstr13")
	if (obj){
	  obj.size=1; 
	  obj.multiple=false;
	  for (var j=1;j<Arr1Area.length;j++){
		  //DHCWeb_HISUIalert(Arr1Area[j])
		  obj.options[j]=new Option(Arr1Area[j].split("^")[3],Arr1Area[j].split("^")[2]);	
		}	  
	}
	
	//性别
	objxbie00=document.getElementById("xbie00")
	if (objxbie00){
	  objxbie00.size=1; 
	  objxbie00.multiple=false;
	  objxbie00.options[1]=new Option("男","1");
	  objxbie00.options[2]=new Option("女","2");
	}
	
	//门诊/住院流水号
	obj=document.getElementById("zylsh0")
	if (obj){
		var NowDate=new Date().toLocaleString()
		NowDate=NowDate.replace("年","")
		NowDate=NowDate.replace("月","")
		NowDate=NowDate.replace("日","")
		NowDate=NowDate.replace(":","")
		NowDate=NowDate.replace(":","")
		NowDate=NowDate.replace(" ","")
		//DHCWeb_HISUIalert(NowDate)
		var objAdmType=document.getElementById("xbie00")
		if (objAdmType.value!=""){
			//zylsh0=objAdmType.value+NowDate+Guser tangzf20190520
			//DHCWeb_HISUIalert(zylsh0)
			obj.value=zylsh0
		}else{
			obj.value=""
		}			
		
	}
}

//更换医保类型
function TariType_onchange(Data) {
    INSUTypeObj = document.getElementById("Zstr04")
    INSUType = INSUTypeObj.value;
	
    //就诊类别
    objAdmType = document.getElementById("Zstr12")
	
    //医疗类别
    var VerStr = "";
    var newDicType = "AKA130" + INSUType;
    VerStr = tkMakeServerCall("web.INSUDicDataCom", "GetSys", "", "", newDicType);
    if (VerStr == "") { DHCWeb_HISUIalert("请在医保字典中维护 [AKA130" + INSUType + "]医疗类别"); return; }
    var Arr1 = VerStr.split("!")
    obj = document.getElementById("sftsbz")
    if (obj) {
        obj.size = 1;
        obj.multiple = false;
        var j = 1
        for (var i = 1; i < Arr1.length; i++) {
            if (Arr1[i].split("^")[5] == objAdmType.value) {
                obj.options[j] = new Option(Arr1[i].split("^")[3], Arr1[i].split("^")[2]);
                if (Arr1[i].split("^")[4] == "Y") { obj.selectedIndex = j }      //取默认值 
                j = j + 1;
            }
        }
    }
	
    //待遇类别
    var VerStr = "";
    var newDicType = "AKC021" + INSUType;
    VerStr = tkMakeServerCall("web.INSUDicDataCom", "GetSys", "", "", newDicType);
    //if ((VerStr=="")||(VerStr=="0")) {DHCWeb_HISUIalert("请在医保字典中维护 [AKC021]待遇类别");return;}
    if (VerStr == "") { DHCWeb_HISUIalert("请在医保字典中维护 [AKC021]待遇类别"); return; }
    var Arr1 = VerStr.split("!")
    objZstr10 = document.getElementById("Zstr10")
    if (objZstr10) {
        objZstr10.size = 1;
        objZstr10.multiple = false;
        for (var i = 1; i < Arr1.length; i++) {
            objZstr10.options[i] = new Option(Arr1[i].split("^")[3], Arr1[i].split("^")[2]);
        }
    }
	
    //医保统筹区
    var VerStrArea = "";
    var newDicType = "YAB003" + INSUType;
    var VerStrArea = tkMakeServerCall("web.INSUDicDataCom", "GetSys", "", "", newDicType);
    //if ((VerStrArea=="")||(VerStrArea=="0")) {DHCWeb_HISUIalert("请在医保字典中维护 [YAB300]医保统筹区");return;}
    if (VerStrArea == "") { DHCWeb_HISUIalert("请在医保字典中维护 [YAB003]医保统筹区"); return; }
    var Arr1Area = VerStrArea.split("!")
    obj = document.getElementById("Zstr13")
    if (obj) {
        obj.size = 1;
        obj.multiple = false;
        for (var j = 1; j < Arr1Area.length; j++) {
            //DHCWeb_HISUIalert(Arr1Area[j])
            obj.options[j] = new Option(Arr1Area[j].split("^")[3], Arr1Area[j].split("^")[2]);
        }
    }
	
	
	
    AdmType_onchange();
	
	
}

//保存垫付信息
function SaveINSUPay_onclick() {
	
    //预留字段1
    var obj = document.getElementById("AdmDr");
    if (obj) { var AdmDr = getValueById('AdmDr'); }
    else { var AdmDr = ""; }
	
    //预留字段2
    var obj = document.getElementById("AdmInfoDr");
    if (obj) { var AdmInfoDr = getValueById('AdmInfoDr'); }
    else { var AdmInfoDr = ""; }
	
    //预留字段3
    var obj = document.getElementById("DHCpblDr");
    if (obj) { var DHCpblDr = getValueById('DHCpblDr'); }
    else { var DHCpblDr = ""; }
	
    //预留字段4
    var obj = document.getElementById("DhcInvPrtDr");
    if (obj) { var DhcInvPrtDr = getValueById('DhcInvPrtDr'); }
    else { var DhcInvPrtDr = ""; }
	
    //结算标志
    var Flag = "I";
	
    //被冲销Rowid
    var INSUDivideDr = "";
	
    //总费用
    var obj = document.getElementById("bcbxf0");
    if (obj) {
        if (getValueById('bcbxf0') == "") {
            DHCWeb_HISUIalert("总费用不能为空！");
            return;
        }
        var bcbxf0 = getValueById('bcbxf0');
    }
	
    //单据号
    var obj = document.getElementById("djlsh0");
    if (obj) {
        if (getValueById('bcbxf0') == "") {
            DHCWeb_HISUIalert("单据号不能为空！");
            return;
        }
        var djlsh0 = getValueById('djlsh0');
    }
	
    //预留字段5
    var obj = document.getElementById("bckbcs");
    if (obj) { var bckbcs = getValueById('bckbcs'); }
    else { var bckbcs = ""; }
	
    //预留字段6
    var obj = document.getElementById("bqbm00");
    if (obj) { var bqbm00 = getValueById('bqbm00'); }
    else { var bqbm00 = ""; }
	
    //预留字段7
    var obj = document.getElementById("brnl00");
    if (obj) { var brnl00 = getValueById('brnl00'); }
    else { var brnl00 = ""; }
	
    //预留字段8
    var obj = document.getElementById("cardno");
    if (obj) { var cardno = getValueById('cardno'); }
    else { var cardno = ""; }
	
    //预留字段9
    var obj = document.getElementById("cfxms0");
    if (obj) { var cfxms0 = getValueById('cfxms0'); }
    else { var cfxms0 = ""; }
	
    //预留字段10
    var obj = document.getElementById("crbcts");
    if (obj) { var crbcts = getValueById('crbcts'); }
    else { var crbcts = ""; }
	
    //个人自付
    var obj = document.getElementById("grzfe0");
    if (obj) {
        if (getValueById('grzfe0') == "") {
            DHCWeb_HISUIalert("个人自付不能为空！");
            return;
        }
        var grzfe0 = getValueById('grzfe0');
    }
	
    //预留字段11
    var obj = document.getElementById("iDate");
    if (obj) { var iDate = getValueById('iDate'); }
    else { var iDate = ""; }
	
    //预留字段12
    var obj = document.getElementById("iTime");
    if (obj) { var iTime = getValueById('iTime'); }
    else { var iTime = ""; }
	
    //身份证号
    var obj = document.getElementById("id0000");
    if (obj) {
        if (getValueById('id0000') == "") {
            DHCWeb_HISUIalert("身份证号不能为空！");
            return;
        }
        var id0000 = getValueById('id0000');
    }
	
    //垫付金额
    var obj = document.getElementById("jjzfe0");
    if (obj) {
        if (getValueById('jjzfe0') == "") {
            DHCWeb_HISUIalert("垫付金额不能为空！");
            return;
        }
        var jjzfe0 = getValueById('jjzfe0');
    }
	
    //预留字段13
    var obj = document.getElementById("ptbcts");
    if (obj) { var ptbcts = obj.value; }
    else { var ptbcts = ""; }
	
    //预留字段14
    var obj = document.getElementById("sfrq00");
    if (obj) { var sfrq00 = obj.value; }
    else { var sfrq00 = ""; }
	
    //操作员
    var sUserDr = Guser;
	
    //预留字段15
    var obj = document.getElementById("sfrxm0");
    if (obj) { var sfrxm0 = obj.value; }
    else { var sfrxm0 = ""; }
	
    //预留字段16
    var obj = document.getElementById("sfsj00");
    if (obj) { var sfsj00 = obj.value; }
    else { var sfsj00 = ""; }
	
    //医疗类别
    var obj = document.getElementById("sftsbz");
    if (obj) {
        if (getValueById('sftsbz') == "") {
            DHCWeb_HISUIalert("医疗类别不能为空！");
            return;
        }
        var sftsbz = getValueById('sftsbz');
    }
	
    //性别
    var obj = document.getElementById("xbie00");
    if (obj) {
        if (getValueById('xbie00') == "") {
            DHCWeb_HISUIalert("性别不能为空！");
            return;
        }
        var xbie00 = getValueById('xbie00')
    }
	
    //姓名
    var obj = document.getElementById("xming0");
    if (obj) {
        obj.value = obj.value.replace('^', '');
        if (getValueById('xming0') == "") {
            DHCWeb_HISUIalert("姓名不能为空！");
            return;
        }
        var xming0 = getValueById('xming0');
    }
	
    //预留字段17
    var obj = document.getElementById("zhzfe0");
    if (obj) { var zhzfe0 = getValueById('zhzfe0'); }
    else { var zhzfe0 = "0.00"; }
	
    //预留字段18
    var obj = document.getElementById("zyksmc");
    if (obj) { var zyksmc = obj.value; }
    else { var zyksmc = ""; }
	
    //门诊/住院流水号
    var obj = document.getElementById("zylsh0");
    if (obj) {
        if (getValueById('zylsh0') == "") {
            DHCWeb_HISUIalert("门诊/住院流水号不能为空！");
            return;
        }
        var zylsh0 = getValueById('zylsh0');
    }
	
    //预留字段19
    var obj = document.getElementById("InsuPay1");
    if (obj) { var InsuPay1 = obj.value; }
    else { var InsuPay1 = "0.00"; }
	
    //预留字段20
    var obj = document.getElementById("InsuPay2");
    if (obj) { var InsuPay2 = obj.value; }
    else { var InsuPay2 = "0.00"; }
	
    //预留字段21
    var obj = document.getElementById("InsuPay3");
    if (obj) { var InsuPay3 = obj.value; }
    else { var InsuPay3 = "0.00"; }
	
    //预留字段22
    var obj = document.getElementById("InsuPay4");
    if (obj) { var InsuPay4 = obj.value; }
    else { var InsuPay4 = "0.00"; }
	
    //预留字段23
    var obj = document.getElementById("InsuPay5");
    if (obj) { var InsuPay5 = obj.value; }
    else { var InsuPay5 = ""; }
	
    //院外报销标志W
    var Zstr01 = "W";
	
    //中途结算标志F（最终结算）
    var Zstr02 = "F";
	
    //预留字段24
    var obj = document.getElementById("Zstr03");
    if (obj) { var Zstr03 = obj.value; }
    else { var Zstr03 = ""; }
	
    //医保类型
    var obj = document.getElementById("Zstr04");
    if (obj) {
        if (getValueById('Zstr04') == "") {
            DHCWeb_HISUIalert("医保类型不能为空！");
            return;
        }
        var Zstr04 = getValueById('Zstr04');
    }
	
    //预留字段25
    var obj = document.getElementById("Zstr05");
    if (obj) { var Zstr05 = obj.value; }
    else { var Zstr05 = ""; }
	
    //预留字段26
    var obj = document.getElementById("Zstr06");
    if (obj) { var Zstr06 = obj.value; }
    else { var Zstr06 = ""; }
	
    //预留字段27
    var obj = document.getElementById("Zstr07");
    if (obj) { var Zstr07 = obj.value; }
    else { var Zstr07 = ""; }
	
    //预留字段28
    var obj = document.getElementById("Zstr08");
    if (obj) { var Zstr08 = obj.value; }
    else { var Zstr08 = ""; }
	
    //预留字段29
    var obj = document.getElementById("Zstr09");
    if (obj) { var Zstr09 = obj.value; }
    else { var Zstr09 = ""; }
	
    //待遇类别
    var obj = document.getElementById("Zstr10");
    if (obj) {
        if (getValueById('Zstr10') == "") {
            DHCWeb_HISUIalert("待遇类别不能为空！");
            return;
        }
        var Zstr10 = getValueById('Zstr10');
    }
	
    //预留字段30
    var obj = document.getElementById("InsuPay6");
    if (obj) { var InsuPay6 = obj.value; }
    else { var InsuPay6 = "0.00"; }
	
    //预留字段31
    var obj = document.getElementById("InsuPay7");
    if (obj) { var InsuPay7 = obj.value; }
    else { var InsuPay7 = "0.00"; }
	
    //预留字段32
    var obj = document.getElementById("InsuPay8");
    if (obj) { var InsuPay8 = obj.value; }
    else { var InsuPay8 = "0.00"; }
	
    //预留字段33
    var obj = document.getElementById("InsuPay9");
    if (obj) { var InsuPay9 = obj.value; }
    else { var InsuPay9 = "0.00"; }
	
    //预留字段34
    var obj = document.getElementById("InsuPay10");
    if (obj) { var InsuPay10 = obj.value; }
    else { var InsuPay10 = "0.00"; }
	
    //预留字段35
    var obj = document.getElementById("Zstr11");
    if (obj) { var Zstr11 = obj.value; }
    else { var Zstr11 = ""; }
	
    //就诊类型
    var obj = document.getElementById("Zstr12");
    if (obj) {
        if (getValueById('Zstr12') == "") {
            DHCWeb_HISUIalert("就诊类型不能为空！");
            return;
        }
        var Zstr12 = getValueById('Zstr12');
    }
	
    //地区
    var obj = document.getElementById("Zstr13");
    if (obj) {
        if (getValueById('Zstr13') == "") {
            DHCWeb_HISUIalert("地区不能为空！");
            return;
        }
        var Zstr13 = getValueById('Zstr13');
    }
	
    //预留字段36
    var obj = document.getElementById("Zstr14");
    if (obj) { var Zstr14 = obj.value; }
    else { var Zstr14 = ""; }
	
    //预留字段37
    var obj = document.getElementById("Zstr15");
    if (obj) { var Zstr15 = obj.value; }
    else { var Zstr15 = ""; }
	
    //转诊医院
    var obj = document.getElementById("Zstr16");
    if (obj) {
        var Zstr16 = obj.value;
    }
	
    //预留字段38
    var obj = document.getElementById("Zstr17");
    if (obj) { var Zstr17 = obj.value; }
    else { var Zstr17 = ""; }
	
    //预留字段39
    var obj = document.getElementById("Zstr18");
    if (obj) { var Zstr18 = obj.value; }
    else { var Zstr18 = ""; }
	
    //预留字段40
    var obj = document.getElementById("Zstr19");
    if (obj) { var Zstr19 = obj.value; }
    else { var Zstr19 = ""; }
	
    //预留字段41
    var obj = document.getElementById("Zstr20");
    if (obj) { var Zstr20 = obj.value; }
    else { var Zstr20 = ""; }
	
    //预留字段42
    var obj = document.getElementById("Zstr21");
    if (obj) { var Zstr21 = obj.value; }
    else { var Zstr21 = ""; }
	
    //预留字段43
    var obj = document.getElementById("Zstr22");
    if (obj) { var Zstr22 = obj.value; }
    else { var Zstr22 = ""; }
	
    //预留字段44
    var obj = document.getElementById("Zstr23");
    if (obj) { var Zstr23 = obj.value; }
    else { var Zstr23 = ""; }
	
    //备注
    var obj = document.getElementById("Zstr24");
    if (obj) { var Zstr24 = obj.value; }
    else { var Zstr24 = ""; }
	
    //预留字段45
    var obj = document.getElementById("Zstr25");
    if (obj) { var Zstr25 = obj.value; }
    else { var Zstr25 = ""; }
	
    //预留字段46
    var obj = document.getElementById("Zstr26");
    if (obj) { var Zstr26 = obj.value; }
    else { var Zstr26 = ""; }
	
    //预留字段47
    var obj = document.getElementById("Zstr27");
    if (obj) { var Zstr27 = obj.value; }
    else { var Zstr27 = ""; }
	
    //预留字段48
    var obj = document.getElementById("Zstr28");
    if (obj) { var Zstr28 = obj.value; }
    else { var Zstr28 = ""; }
	
    //预留字段49
    var obj = document.getElementById("Zstr29");
    if (obj) { var Zstr29 = obj.value; }
    else { var Zstr29 = ""; }
	
    //预留字段50
    var obj = document.getElementById("Zstr30");
    if (obj) { var Zstr30 = obj.value; }
    else { var Zstr30 = ""; }
	
    //预留字段51
    var obj = document.getElementById("Zstr31");
    if (obj) { var Zstr31 = obj.value; }
    else { var Zstr31 = ""; }
	
    if (bcbxf0 != (jjzfe0 * 1 + grzfe0 * 1)) {
        DHCWeb_HISUIalert("总费用不等于垫付金额+个人自付，请录入正确的金额！");
    } else {
        //Divide表的rowid(保存时传空,作废时必传)^预留1^预留2^预留3^预留4^结算状态(正常:I,被作废:B,作废:S)^被冲销rowid^总费用^单据号^预留5^预留6^预留7^预留8^预留9^预留10^个人自付^预留11^预留12^身份证号^垫付金额^预留13^用户ID^预留14^预留15^预留16^医疗类别^性别^姓名^预留17^预留18^门诊/住院流水号^预留19^预留20^预留21^预留22^预留23^院外报销标志^中途结算标志^预留24^医保类型^预留25^预留26^预留27^预留28^预留29^待遇类别^预留30^预留31^预留32^预留33^预留34^预留35^就诊类型^地区^预留36^预留37^转诊医院^预留38^预留39^预留40^预留41^预留42^预留43^预留44^备注^预留45^预留46^预留47^预留48^预留49^预留50^预留51
        var InStr = "" + "^" + AdmDr + "^" + AdmInfoDr + "^" + DHCpblDr + "^" + DhcInvPrtDr + "^" + Flag + "^" + INSUDivideDr + "^" + bcbxf0 + "^" + djlsh0 + "^" + bckbcs + "^" + bqbm00 + "^" + brnl00 + "^" + cardno + "^" + cfxms0 + "^" + crbcts + "^" + grzfe0 + "^" + iDate + "^" + iTime + "^" + id0000 + "^" + jjzfe0 + "^" + ptbcts + "^" + sUserDr + "^" + sfrq00 + "^" + sfrxm0 + "^" + sfsj00 + "^" + sftsbz + "^" + xbie00 + "^" + xming0 + "^" + zhzfe0 + "^" + zyksmc + "^" + zylsh0 + "^" + InsuPay1 + "^" + InsuPay2 + "^" + InsuPay3 + "^" + InsuPay4 + "^" + InsuPay5 + "^" + Zstr01 + "^" + Zstr02 + "^" + Zstr03 + "^" + Zstr04 + "^" + Zstr05 + "^" + Zstr06 + "^" + Zstr07 + "^" + Zstr08 + "^" + Zstr09 + "^" + Zstr10 + "^" + InsuPay6 + "^" + InsuPay7 + "^" + InsuPay8 + "^" + InsuPay9 + "^" + InsuPay10 + "^" + Zstr11 + "^" + Zstr12 + "^" + Zstr13 + "^" + Zstr14 + "^" + Zstr15 + "^" + Zstr16 + "^" + Zstr17 + "^" + Zstr18 + "^" + Zstr19 + "^" + Zstr20 + "^" + Zstr21 + "^" + Zstr22 + "^" + Zstr23 + "^" + Zstr24 + "^" + Zstr25 + "^" + Zstr26 + "^" + Zstr27 + "^" + Zstr28 + "^" + Zstr29 + "^" + Zstr30 + "^" + Zstr31;
        //DHCWeb_HISUIalert(InStr)
        var Ins = document.getElementById('SaveIDivideInfo');
        if (Ins) { var encmeth = Ins.value } else { var encmeth = '' };
        var OutStr = cspRunServerMethod(encmeth, InStr);
        if (OutStr > 0) {
            $.messager.alert('提示', '垫付成功', 'info', function () {
                $('#Find').click();
		 			
            })
        } else {
            if (OutStr == -4) { DHCWeb_HISUIalert("垫付失败！系统中已经存在此医保系统结算号:" + djlsh0 + ",请查证后再录入！"); }
        }
    }
}

//清屏
function ClearPage_onclick() {
	/*
	//身份证号
	var obj=document.getElementById("id0000");
	if (obj){ obj.value="";}
	//姓名
	var obj=document.getElementById("xming0");
	if (obj){ obj.value="";}
	//总费用
	var obj=document.getElementById("bcbxf0");
	if (obj){ obj.value="";}
	//垫付金额
	var obj=document.getElementById("jjzfe0");
	if (obj){ obj.value="";}
	//个人自付
	var obj=document.getElementById("grzfe0");
	if (obj){ obj.value="";}
	//转诊医院
	var obj=document.getElementById("Zstr16");
	if (obj){ obj.value="";}
	//门诊/住院流水号
	var obj=document.getElementById("zylsh0");
	if (obj){ obj.value="";}
	//单据号
	var obj=document.getElementById("djlsh0");
	if (obj){ obj.value="";}
	//备注
	var obj=document.getElementById("Zstr24");
	if (obj){ obj.value="";}
	//开始日期
	var obj=document.getElementById("StartDate");
	if (obj){ obj.value="";}
	//结束日期
	var obj=document.getElementById("EndDate");
	if (obj){ obj.value="";}*/
    //Find_click();
    location.reload();
	
}
function AdmType_onchange() {
    var objAdmType = document.getElementById("Zstr12");
    var newDicType = "AKA130" + INSUType;
    var VerStr = "";
    VerStr = tkMakeServerCall("web.INSUDicDataCom", "GetSys", "", "", newDicType);
    if (VerStr == "") { DHCWeb_HISUIalert("请在医保字典中维护 [AKA130]医疗类别"); return; }
    var Arr1 = VerStr.split("!")
    obj = document.getElementById("sftsbz")
    if (obj) {
        obj.options.length = 0
        obj.size = 1;
        obj.multiple = false;
        var j = 1
        for (var i = 1; i < Arr1.length; i++) {
            if ((Arr1[i].split("^")[8] == objAdmType.value) || ((Arr1[i].split("^")[8] == "") && (objAdmType.value == "OP"))) {
                obj.options[j] = new Option(Arr1[i].split("^")[3], Arr1[i].split("^")[2]);
                if (Arr1[i].split("^")[4] == "Y") { obj.selectedIndex = j }      //取默认值
                j = j + 1;
            }
        }
    }
	
    //门诊/住院流水号
    obj = document.getElementById("zylsh0")
    if (obj) {
        var NowDate = new Date().toLocaleString()
        NowDate = NowDate.replace("年", "")
        NowDate = NowDate.replace("月", "")
        NowDate = NowDate.replace("日", "")
        NowDate = NowDate.replace(":", "")
        NowDate = NowDate.replace(":", "")
        NowDate = NowDate.replace(" ", "")
        //DHCWeb_HISUIalert(NowDate)
        if (objAdmType.value != "") {
            zylsh0 = objAdmType.value + NowDate + Guser
            //DHCWeb_HISUIalert(zylsh0)
            obj.value = zylsh0
        } else {
            obj.value = ""
        }
		
    }
}

function PatType_onchange() {
    var objAdmType = document.getElementById("Zstr12")
    var objZstr10 = document.getElementById("Zstr10")
    if (objZstr10.value == "") {
        var objsftsbz = document.getElementById("sftsbz")
        DHCC_ClearList("sftsbz");
        if (objsftsbz) {
            objsftsbz.size = 1;
            objsftsbz.multiple = false;
            objsftsbz.options[0] = new Option("", "");
        }
    } else {
        var DicType = objAdmType.value + objZstr10.value;
        var VerStr = tkMakeServerCall("web.INSUDicDataCom", "GetSys", "", "", DicType);
        if ((VerStr == "") || (VerStr == "0")) { DHCWeb_HISUIalert("请在医保字典中维护 医疗类别"); return; }
        var Arr1 = VerStr.split("!")
        var objsftsbz = document.getElementById("sftsbz")
        DHCC_ClearList("sftsbz");
        if (objsftsbz) {
            objsftsbz.size = 1;
            objsftsbz.multiple = false;
            for (var k = 1; k < Arr1.length; k++) {
                objsftsbz.options[k] = new Option(Arr1[k].split("^")[3], Arr1[k].split("^")[2]);
            }
        }
    }
}

function SelectRowHandler(index, RowData) {
    if (index > -1) {
        //DHCWeb_HISUIalert("你选择的是第"+selectedRowObj.rowIndex+"行");
		
        //获取选择的当前行的TRowID的文本值
        //var obj=document.getElementById("TRowIDz"+selectedRowObj.rowIndex);
        var TRowID = RowData.TRowID;
        //DHCWeb_HISUIalert(TRowID)
        //获取选择的当前行的Tdjlsh0的文本值
        //var objTdjlsh0=document.getElementById("Tdjlsh0z"+selectedRowObj.rowIndex);
        var Tdjlsh0 = RowData.Tdjlsh0; //objTdjlsh0.innerText;
        //DHCWeb_HISUIalert(Tdjlsh0)
        //获取选择的当前行的TFlag的文本值
        //var objTFlag=document.getElementById("TFlagz"+selectedRowObj.rowIndex);
        var FlagHidden = RowData.TFlag;
        //DHCWeb_HISUIalert(FlagHidden)
        //赋值隐藏变量RowID
        //var objRowID=document.getElementById("RowID");
        //objRowID.value=TRowID;
        setValueById('RowID', TRowID);
        //赋值隐藏变量INSUDjlshHidden
        //var objINSUDjlshHidden=document.getElementById("INSUDjlshHidden");
        //objINSUDjlshHidden.value=Tdjlsh0;
        setValueById('INSUDjlshHidden', Tdjlsh0);
        //赋值隐藏变量FlagHidden
        //var objFlagHidden=document.getElementById("FlagHidden");
        //objFlagHidden.value=FlagHidden;
        setValueById('FlagHidden', FlagHidden);
		
        //获取选择的当前行的文本值给界面赋值
		/* tangzf 2019-9-3
		
		document.getElementById("djlsh0").value=document.getElementById("Tdjlsh0z"+selectedRowObj.rowIndex).innerText;
		document.getElementById("zylsh0").value=document.getElementById("Tzylsh0z"+selectedRowObj.rowIndex).innerText;
		document.getElementById("xming0").value=document.getElementById("Txming0z"+selectedRowObj.rowIndex).innerText;
		//document.getElementById("xbie00").value=document.getElementById("Txbie00z"+selectedRowObj.rowIndex).innerText;
		document.getElementById("id0000").value=document.getElementById("Tid0000z"+selectedRowObj.rowIndex).innerText;
		//document.getElementById("Zstr13").value=document.getElementById("TZstr13z"+selectedRowObj.rowIndex).innerText;
		//document.getElementById("Zstr12").value=document.getElementById("TZstr12z"+selectedRowObj.rowIndex).innerText;
		//document.getElementById("sftsbz").value=document.getElementById("Tsftsbzz"+selectedRowObj.rowIndex).innerText;
		//document.getElementById("Zstr10").value=document.getElementById("TZstr10z"+selectedRowObj.rowIndex).innerText;
		document.getElementById("Zstr16").value=document.getElementById("TZstr16z"+selectedRowObj.rowIndex).innerText;
		document.getElementById("bcbxf0").value=document.getElementById("Tbcbxf0z"+selectedRowObj.rowIndex).innerText;
		document.getElementById("jjzfe0").value=document.getElementById("Tjjzfe0z"+selectedRowObj.rowIndex).innerText;
		document.getElementById("grzfe0").value=document.getElementById("Tgrzfe0z"+selectedRowObj.rowIndex).innerText;
		document.getElementById("Zstr24").value=document.getElementById("TZstr24z"+selectedRowObj.rowIndex).innerText;
		*/
        setValueById('Zstr04', RowData.TZstr04);
        setValueById('djlsh0', RowData.Tdjlsh0);
        setValueById('zylsh0', RowData.Tzylsh0);
        setValueById('xming0', RowData.Txming0);
        setValueById('xbie00', RowData.Tbie00);
        setValueById('id0000', RowData.Tid0000);
        setValueById('Zstr13', RowData.TZstr13);
        setValueById('Zstr12', RowData.TZstr12);
        setValueById('sftsbz', RowData.Tsftsbz);
        setValueById('Zstr10', RowData.TZstr10);
        setValueById('Zstr16', RowData.TZstr16);
        setValueById('bcbxf0', RowData.Tbcbxf0);
        setValueById('jjzfe0', RowData.Tjjzfe0);
        setValueById('grzfe0', RowData.Tgrzfe0);
        setValueById('Zstr24', RowData.TZstr24);
		
    } else {
        //赋值隐藏变量RowID
        //var objRowID=document.getElementById("RowID");
        //objRowID.value="";
        setValueById('RowID', '');
        //赋值隐藏变量INSUDjlshHidden
        //var objINSUDjlshHidden=document.getElementById("INSUDjlshHidden");
        //objINSUDjlshHidden.value="";
        setValueById('INSUDjlshHidden', '');
        //赋值隐藏变量FlagHidden
        //var objFlagHidden=document.getElementById("FlagHidden");
        //objFlagHidden.value="";
        setValueById('FlagHidden', '');
    }
}

//作废
function DivideStrike_onclick() {
    //从隐藏变量中提取赋值变量TRowID
    var objRowID = document.getElementById("RowID");
    var TRowID = getValueById('RowID');
    //从隐藏变量中提取赋值变量INSUDjlshHidden
    var objINSUDjlshHidden = document.getElementById("INSUDjlshHidden");
    var Tdjlsh0 = getValueById('INSUDjlshHidden');
    //从隐藏变量中提取赋值变量TFlagHidden
    var objFlagHidden = document.getElementById("FlagHidden");
    var TFlagHidden = getValueById('FlagHidden');
	
    if ((TRowID == "") || (Tdjlsh0 == "") || (TFlagHidden == "")) { DHCWeb_HISUIalert("请选中要作废的记录！"); return; }
	
    if (TFlagHidden != "正常结算") {
        DHCWeb_HISUIalert("不允许作废已冲销的费用！请重新选择！");
        return;
    }

    //用户ID^单据号^Divide表的rowid(作废时必传)^结算状态(正常:I,被作废:B,作废:S)
    var InStr = Guser + "^" + Tdjlsh0 + "^" + TRowID + "^S"
    //DHCWeb_HISUIalert(InStr)
    var Ins = document.getElementById('StrikeDivideInfo');
    if (Ins) { var encmeth = Ins.value } else { var encmeth = '' };
    var OutStr = cspRunServerMethod(encmeth, InStr);
    if (OutStr > 0) {
        $.messager.alert('提示', '作废成功！', 'info', function () {
            $('#Find').click();
        })
    } else {
        if (OutStr == -5) { DHCWeb_HISUIalert("作废失败！系统中保存的医保系统结算号与页面显示的结算号不同，作废失败！"); }
    }
}

function Jjzfe0_onkeydown() {
    var obj = document.getElementById("bcbxf0");
    var Total = obj.value;
    if (Total == "") {
        DHCWeb_HISUIalert("请先输入总金额！");
        setValueById("bcbxf0", '');

    }
    if (isNaN(Total)) {
        DHCWeb_HISUIalert("请输入正确的总金额！");
        setValueById("bcbxf0", '');
    } else {
        if (Total * 1 < 0) {
            DHCWeb_HISUIalert("总金额不能小于0！");
            setValueById("bcbxf0", '');
        } else {
            obj = document.getElementById("jjzfe0");
            var jjzfe0 = obj.value;
            if (jjzfe0 == "") {
                DHCWeb_HISUIalert("请先输入垫付金额！");
                setValueById("jjzfe0", '');
            }
            if (isNaN(jjzfe0)) {
                DHCWeb_HISUIalert("请输入正确的垫付金额！");
                setValueById("jjzfe0", '');
                setValueById("grzfe0", '');
            } else {
                if (jjzfe0 * 1 < 0) {
                    DHCWeb_HISUIalert("垫付金额不能小于0！");
                    setValueById("grzfe0", '');
                    setValueById("jjzfe0", '');
                } else {
                    if (Total * 1 < jjzfe0 * 1) {
                        DHCWeb_HISUIalert("总金额不能小于垫付金额！");
                        setValueById("grzfe0", '');
                        setValueById("jjzfe0", '');
                    }
                    else {
                        obj = document.getElementById("grzfe0");
                        obj.value = (Total * 1 - jjzfe0 * 1);//.toFixed(2);
                    }
                }

            }

        }
    }
}

function Djlsh0_onkeydown() {
    if (window.event.keyCode == 13) {
        $('#Find').click();
    }
}
function init_Layout() {
    $('td.i-tableborder>table').css("border-spacing", "0px 8px"); // 行间距
    $('#cStartDate').css('margin-left', '4px'); // 左边框距离
    init_INSUType(); //医保类型
    init_AdmType(); // 就诊类型
    init_Sex(); // 性别
    setValueById('StartDate', getDefStDate(0)); // 开始日期
    setValueById('EndDate', getDefStDate(0)); // 结束日期	
	
    $('#tINSUOutOfHospitPay').datagrid({
        frozenColumns: [[
            {
                field: 'Txming0',
                title: '姓名',
            }, {
                field: 'Tzylsh0',
                title: '流水号',
            },
        ]],
        onLoadSuccess: function (data) {
            $('.datagrid-sort-icon').text(''); // 金额列 文字和金额右对齐
            $('.datagrid-view2').find('td[field=Tzylsh0]').hide();
            $('.datagrid-view2').find('td[field=Txming0]').hide();
        }
    });
    $('#grzfe0').attr('readonly', true);
    $('#bcbxf0').css('color', 'red');
    $('#jjzfe0').css('color', 'red');
    $('#grzfe0').css('color', 'red');	
}
function init_INSUType() {
    //医保类型
	
    $("#Zstr04").combobox({
        valueField: 'cCode',
        textField: 'cDesc',
        url: $URL,
        fit: true,
        loadFilter: function (data) {
            data.splice(data.length - 1, 1) // 把query返回的 全部 去掉
            return data;
        },
        onBeforeLoad: function (param) {
            param.ResultSetType = 'Array';
            param.ClassName = 'web.INSUDicDataCom';
            param.QueryName = 'QueryDic';
            param.Type = 'DLLType';
            param.Code = '';
        },
        onSelect: function (Data) {
            //TariType_onchange(Data);
            init_YLLB(); //医疗类别
            init_DYLB(); // 待遇类别
            init_States(); // 统筹区
        },
        onLoadSuccess: function (data) {
            if (data.length == 0) {
                DHCWeb_HISUIDHCWeb_HISUIalert("请在医保字典中维护 [DLLType]");
            }
        }		
    })
}
// 医疗类别
function init_YLLB() {
    $("#sftsbz").combobox({
        valueField: 'cCode',
        textField: 'cDesc',
        url: $URL,
        fit: true,
        loadFilter: function (data) {
            data.splice(data.length - 1, 1) // 把query返回的 全部 去掉
            return data;
        },
        onBeforeLoad: function (param) {
            param.ResultSetType = 'Array';
            param.ClassName = 'web.INSUDicDataCom';
            param.QueryName = 'QueryDic';
            param.Type = 'AKA130' + getValueById('Zstr04');
            param.Code = '';
        },
        onSelect: function (Data) {
        },
        onLoadError: function (e) {
        },
        onLoadSuccess: function (data) {
            if (data.length == 0) {
                DHCWeb_HISUIDHCWeb_HISUIalert("请在医保字典中维护 [AKA130" + getValueById('Zstr04') + "]医疗类别");
            }
        }
    })
	
}
// 就诊类别
function init_AdmType() {
    $HUI.combobox("#Zstr12", {
        valueField: 'id',
        textField: 'text',
        data: [{
            "id": 'OP',
            "text": "门诊",
        }, {
            "id": 'IP',
            "text": "住院"
        }],
        onSelect: function (Data) {
            var rtn = tkMakeServerCall('web.INSUOutOfHospitalCtl', 'Buildzylsh0ByDateUser', Data.id, Guser);
            setValueById('zylsh0', rtn);
        },
    })
}
// 性别
function init_Sex() {
    $HUI.combobox("#xbie00", {
        valueField: 'id',
        textField: 'text',
        data: [{
            "id": '1',
            "text": "男",
            selected: true
        }, {
            "id": '2',
            "text": "女"
        }],
    })	
}
function init_DYLB() {
    //待遇类别
    $("#Zstr10").combobox({
        valueField: 'cCode',
        textField: 'cDesc',
        url: $URL,
        fit: true,
        loadFilter: function (data) {
            data.splice(data.length - 1, 1) // 把query返回的 全部 去掉
            return data;
        },
        onBeforeLoad: function (param) {
            param.ResultSetType = 'Array';
            param.ClassName = 'web.INSUDicDataCom';
            param.QueryName = 'QueryDic';
            param.Type = 'AKC021' + getValueById('Zstr04');
            param.Code = '';
        },
        onSelect: function (Data) {
        },
        onLoadError: function (e) {
        },
        onLoadSuccess: function (data) {
            if (data.length == 0) {
                DHCWeb_HISUIDHCWeb_HISUIalert("请在医保字典中维护 [AKC021" + getValueById('Zstr04') + "]待遇类别");
            }
        }
    })
}
function init_States() {
    // 统筹区
    $("#Zstr13").combobox({
        valueField: 'cCode',
        textField: 'cDesc',
        url: $URL,
        fit: true,
        loadFilter: function (data) {
            data.splice(data.length - 1, 1) // 把query返回的 全部 去掉
            return data;
        },
        onBeforeLoad: function (param) {
            param.ResultSetType = 'Array';
            param.ClassName = 'web.INSUDicDataCom';
            param.QueryName = 'QueryDic';
            param.Type = 'YAB003' + getValueById('Zstr04');
            param.Code = '';
        },
        onSelect: function (Data) {
        },
        onLoadError: function (e) {
        },
        onLoadSuccess: function (data) {
            if (data.length == 0) {
                DHCWeb_HISUIDHCWeb_HISUIalert("请在医保字典中维护 [YAB003" + getValueById('Zstr04') + "]待遇类别");
            }
        }
    })
}
document.body.onload = BodyLoadHandler;