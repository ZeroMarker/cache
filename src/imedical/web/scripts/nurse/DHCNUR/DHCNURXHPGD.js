var ret = "";

var checkret = "";

var comboret = "";

var arrgrid = new Array();



function formatDate(value) {

	try

	{

		return value ? value.dateFormat('Y-m-d') : '';

	} catch (err)

	{

		return '';

	}

};

function eachItem1(item, index, length) {

	if (item.xtype == "datefield") {

		//修改下拉框的请求地址    

		ret = ret + item.id + "|" + formatDate(item.getValue()) + "^";



	}

	if (item.xtype == "timefield") {

		//修改下拉框的请求地址    

		//debugger;

		ret = ret + item.id + "|" + item.getValue() + "^";



	}

	if (item.xtype == "combo") {

		//修改下拉框的请求地址    

		
				comboret = comboret + item.id + "|" + item.getValue() + "!" + item.lastSelectionText + "^";
		


	}

	if (item.xtype == "textfield") {

		//修改下拉框的请求地址    

		//debugger;

		ret = ret + item.id + "|" + item.getValue() + "^";



	}

	if (item.xtype == "textarea") {

		//修改下拉框的请求地址    

		ret = ret + item.id + "|" + item.getRawValue() + "^";



	}

	if (item.xtype == "checkbox") {

		//修改下拉框的请求地址    

		//debugger;

		if (item.checked == true) checkret = checkret + item.id + "|" + item.boxLabel + "^";



	}



	if (item.items && item.items.getCount() > 0) {

		item.items.each(eachItem1, this);

	}

}

var insrtCurrentId = "" //全局变量

function InitEventZSK()

{

	var arrLength = arr.length;

	var zskObj;

	for (var i = 0; i < arrLength; ++i)

	{

		if ((arr[i].xtype == "textfield") || (arr[i].xtype == "textarea"))

		{

			zskObj = Ext.getCmp(arr[i].id);

			zskObj.on('focus', GetItemId);

		}

	}

}



function GetItemId()

{

	insrtCurrentId = this.id;

}

var StartLock = "0" //续打全院开关：1:启用续打，0:不启用续打

var IfMakePic = "" //是否生成图片

var WillUpload = "" //是否上传ftp

var prnmode = tkMakeServerCall("User.DHCNURMoudelLink", "getPrintCode", EmrCode) //根据界面模板获取打印模板

var prnmcodes = ""

if (prnmode != "")

{

	var prnarr = prnmode.split('|')

	prnmcodes = prnarr[0]

	IfMakePic = prnarr[3] //是否生成图片

	WillUpload = prnarr[4] //是否上传ftp

	//alert(WillUpload)

	if (prnarr[2] == "Y") //启用续打

	{

		StartLock = "1"

	} else

	{

		StartLock = "0"

	}

}

if ((StartLock == "1") && (prnmode == ""))

{

	alert("请关联界面模板和打印模板!")

	StartLock = "0" //关闭续打

}

var printcolor = '#C9C9C9'; //已打印颜色

var havechangecolor = '#FF8247' //有修改颜色

var noprintcolor = '#FFFFF0'; //未打印颜色

var Startcolor = '#1E90FF'; //从该条开始打印的颜色

var prncode = prnmcodes //打印模板名称

var Startloc = "" //启用续打的科室科室（前提必须是StartLock=1）

var ITypItm = "Item54"; //后取数据字典型

function BodyLoadHandler() {

	//var but=Ext.getCmp("butClose");



	InitEventZSK();

	// but.on('click',btclose);

	var but = Ext.getCmp("butSave");

	but.on('click', Save);

	var but = Ext.getCmp("butPrint");

	but.on('click', function(){
		 butPGDPrintFn('DHCNURMouldPGDPrn')
	});

	//var GetQueryData=document.getElementById('GetQueryData');



	var Item2 = Ext.getCmp("Item54");

	//alert(session['LOGON.USERID']);

	Item2.on('specialkey', cmbkey);

	//ITypItm="Item2";

	//setVal2(ExamId);

	setvalue()

	if (userstr != "")

	{

		getuserha()

	}

	setzkinit() //质控初始化

	//alert(SpId);
	//getPatInfo();

	var patName = Ext.getCmp("Item1");



	patName.disable()

	var sex = Ext.getCmp("Item41");

	sex.disable()

	var regno = Ext.getCmp("Item5");

	regno.disable()

	var age = Ext.getCmp("Item2");

	age.disable()

	var patLoc = Ext.getCmp("Item3");

	patLoc.disable()

	var bedCode = Ext.getCmp("Item5");

	bedCode.disable()

	var diag = Ext.getCmp("Item14");

	//diag.disable()

	var TEL = Ext.getCmp("Item9");

	//TEL.disable()

	var admdate = Ext.getCmp("Item10");

	admdate.disable()

	var admtime = Ext.getCmp("Item11");

	admtime.disable()

	var medicano = Ext.getCmp("Item6");

	medicano.disable()

	var Item45 = Ext.getCmp("Item45");

	var Item46 = Ext.getCmp("Item46");

	Item45.setVisible(false)

	Item46.setVisible(false)

	var Item111 = Ext.getCmp("Item43_2");

	var Item131 = Ext.getCmp("Item44_2");

	var Item211 = Ext.getCmp("Item43_1");

	var Item231 = Ext.getCmp("Item44_1");

	Item111.on("check", function()

		{

			var dd11 = Item111.getValue()

			if (dd11 == true)

			{
				Item211.setValue(false)

				Item45.setVisible(true)

			}

		})

	Item211.on("check", function()

		{

			var dd11 = Item211.getValue()

			if (dd11 == true)

			{

				Item111.setValue(false)

				Item45.setVisible(false)

				Item45.setValue("")

			}

		})

	Item131.on("check", function()

		{

			var dd11 = Item131.getValue()

			if (dd11 == true)

			{

				Item231.setValue(false)

				Item46.setVisible(true)

			}

		})

	Item231.on("check", function()

		{

			var dd11 = Item231.getValue()

			if (dd11 == true)

			{

				Item131.setValue(false)

				Item46.setVisible(false)

				Item46.setValue("")

				//Item46.setVisible(true)    		

			}

		})

	var Item43_2 = Ext.getCmp("Item43_2");
	var Item44_2 = Ext.getCmp("Item44_2");
	var Item451 = Ext.getCmp("Item45");
	var Item461 = Ext.getCmp("Item46");
	var value43_2 = Item43_2.getValue();
	if (Item43_2.getValue() == true) {
		Item451.setVisible(true);
	}
	if (Item44_2.getValue() == true) {
		Item461.setVisible(true);
	}
	/*var Item57=Ext.getCmp("Item57");
	if(Item57)
	{
		Item57.triggerAction='all';
		Item57.forceSelection=true;
		Item57.typeAhead=false;
		Item57.store.on('beforeload',function(){
				Item57.store.baseParams.typ=Item57.lastQuery;	
			})
	}*/
}

function setVal2(itm, val)

{

	if (val == "") return;

	var tt = val.split('!');

	//alert(tt);

	var cm = Ext.getCmp(itm);

	person = new Array();

	addperson(tt[1], tt[0]);

	cm.store.loadData(person);

	cm.setValue(tt[0]);



}

function cmbkey(field, e)

{

	if (e.getKey() == Ext.EventObject.ENTER)

	{

		var pp = field.lastQuery;
		alert(pp)
		getlistdata(pp, field);

		//	alert(ret);



	}

}

var person = new Array();

function getlistdata(p, cmb)

{

	var GetPerson = document.getElementById('GetPerson');

	//debugger;

	var ret = cspRunServerMethod(GetPerson.value, p);

	if (ret != "")

	{

		var aa = ret.split('^');

		for (i = 0; i < aa.length; i++)

		{

			if (aa[i] == "") continue;

			var it = aa[i].split('|');

			addperson(it[1], it[0]);

		}

		//debugger;

		cmb.store.loadData(person);

	}

}

function addperson(a, b)

{

	person.push(

		{

			desc: a,

			id: b

		}

	);

}



function btclose()

{

	window.close();

}



function cmbkey(field, e)

{

	if (e.getKey() == Ext.EventObject.ENTER)

	{

		var pp = field.lastQuery;

		getlistdata(pp, field);

		//	alert(ret);



	}

}

var person = new Array();

function getlistdata(p, cmb)

{

	var GetPerson = document.getElementById('GetPerson');

	//debugger;

	var ret = cspRunServerMethod(GetPerson.value, p);

	if (ret != "")

	{

		var aa = ret.split('^');

		for (i = 0; i < aa.length; i++)

		{

			if (aa[i] == "") continue;

			var it = aa[i].split('|');

			addperson(it[1], it[0]);

		}

		//debugger;

		cmb.store.loadData(person);

	}

}

function addperson(a, b)

{

	person.push(

		{

			desc: a,

			id: b

		}

	);

}



function AddRec(str)

{

	//var a=new Object(eval(str));

	var obj = eval('(' + str + ')');

	arrgrid.push(obj);

	//debugger;

}

function setvalue()

{

	//alert(ExamId);

	var ha = new Hashtable();

	var getid = document.getElementById('GetId');

	var id = cspRunServerMethod(getid.value, EmrCode, EpisodeID);

	// alert(id);

	if (id != "") {

		var getVal = document.getElementById('getVal');

		var ret = cspRunServerMethod(getVal.value, id);

		//	alert(ret);

		var tm = ret.split('^')

		//alert(tm);

		sethashvalue(ha, tm);

		//getPatInfo();

	} else {

		//alert("dd");

		getPatInfo();

		return;

		//var PatInfo = document.getElementById('PatInfo');

		//if (PatInfo) {

		//alert(12);

		//var ret = cspRunServerMethod(PatInfo.value, EpisodeID, EmrCode);

		//var tm = ret.split('^')

		//sethashvalue(ha, tm)

	}



	// debugger;



	var gform = Ext.getCmp("gform");

	gform.items.each(eachItem, this);

	//  alert(a);

	for (var i = 0; i < ht.keys().length; i++) //for...in statement get all of Array's index

	{

		var key = ht.keys()[i];

		//restr += ht.items(key) + " " + ht.parent[key] + "<br/>";

		if (key.indexOf("_") == -1)

		{

			//alert(key);

			var flag = ifflag(key);

			if (flag == true)

			{

				if (ha.contains(key)) setVal2(key, ha.items(key));

				//debugger;

				continue;

			}

			var itm = Ext.getCmp(key);

			if (ha.contains(key))

				itm.setValue(getval(ha.items(key)));

				/*Ext.getCmp("Item57").store.load({params:{start:0,limit:100},callback:function(){
		 		if(ha.contains("Item57")){
		 			Ext.getCmp("Item57").typeAhead=false;
					var edustr=ha.items("Item57");
					if(edustr.indexOf('!')>-1)
					{
						Ext.getCmp("Item57").setValue(edustr.split('!')[0]);
					}
		 			
					//alert(ha.items("Item116"))
		 		}
		 	}})*/

		} else {

			var aa = key.split('_');

			if (ha.contains(aa[0]))

			{

				setcheckvalue(key, ha.items(aa[0]));

			}

		}

	}

	//getPatInfo();

}

function getval(itm)

{

	var tm = itm.split('!');

	//	alert(tm)

	return tm[0];

}

function ifflag(itm)

{ //alert(tm);

	var tm = ITypItm.split('|');

	//alert(tm);

	var flag = false;

	for (var i = 0; i < tm.length; i++)

	{

		if (itm == tm[i])

		{

			flag = true;

		}

	}

	return flag;

}

function Save()

{

	ret = "";

	checkret = "";

	comboret = "";

	var getid = document.getElementById('GetId');

	var Id = cspRunServerMethod(getid.value, EmrCode, EpisodeID);

	// alert(Id);

	var SaveRec = document.getElementById('Save');

	var gform = Ext.getCmp("gform");

	gform.items.each(eachItem1, this);

	var flag = Savezk(); //质控

	if (flag == 1)

	{

		alert("红色区域不能为空")

		return

	}

	if (flag == 2)

	{

		// alert("红色区域不能为空")

		return

	}

	//alert(EmrCode)

	//alert(ret+"&"+checkret+"&"+comboret);

	// alert(checkret);

	//alert(ret);

	// alert(comboret);

	var stId = Id

	Id = cspRunServerMethod(SaveRec.value, "^EmrUser|" + session['LOGON.USERID'] + "^EmrCode|" + EmrCode + "^" + ret + "^DetLocDr|" + session['LOGON.CTLOCID'] + "^EpisodeId|" + EpisodeID + "&" + checkret + "&" + comboret, Id);

	//alert(Id);

	alert("已保存");

	if (stId == "")

	{

		window.parent.reloadtree();

	}

	if (IfMakePic == "Y")

	{

		//MakePicture(); //生成图片
		MakePicturePGd("DHCNURMouldPGDPrn")

	}



	//alert(NurRecId);



}

//生成图片

function MakePicture()

{

	if (NurRecId == undefined) NurRecId = ""

	PrintCommPic.StartMakePic = "Y" //图片

	PrintCommPic.WebUrl = WebIp + "/dthealth/web/DWR.DoctorRound.cls";

	PrintCommPic.ItmName = "DHCNURMouldPGDPrn"; //打印模板名称

	var parr = "@" + EpisodeID + "@" + EmrCode;

	PrintCommPic.MthArr = "web.DHCNurMouldDataComm:GetPrnValComm&parr:" + parr;

	PrintCommPic.PrintOut();

	PrintCommPic.NurRecId = NurRecId //图片

	PrintCommPic.EmrCode = EmrCode //图片

	PrintCommPic.EpisodeID = EpisodeID //图片

	PrintCommPic.MakeTemp = "Y"; //图片

	PrintCommPic.filepath = WebIp + "/DHCMG/HLBLMakePictureSet.xml" //图片

	PrintCommPic.MakePicture(); //图片

	//alert(page)



}

function getPatInfo()

{

	//return ;

	var PatInfo = document.getElementById('PatInfo');

	if (PatInfo) {

		var ret = cspRunServerMethod(PatInfo.value, EpisodeID);

		//alert(ret);

		var tt = ret.split('^');

		var patName = Ext.getCmp("Item1");

		patName.setValue(getValueByCode(tt[4]));

		patName.disable()

		var sex = Ext.getCmp("Item41");

		sex.setValue(getValueByCode(tt[3]));

		var regno = Ext.getCmp("Item5");

		regno.setValue(getValueByCode(tt[0]));

		var age = Ext.getCmp("Item2");

		age.setValue(getValueByCode(tt[6]));

		var patLoc = Ext.getCmp("Item3");

		patLoc.setValue(getValueByCode(tt[1]));

		var bedCode = Ext.getCmp("Item5");

		bedCode.setValue(getValueByCode(tt[5]));

		var AdmDiag=tkMakeServerCall("web.DHCNurMouldDataComm","getPatAdmDiag",EpisodeID);
		var diag = Ext.getCmp("Item14");

		diag.setValue(getValueByCode(tt[8]));


		//var TEL= Ext.getCmp("Item9");

		//TEL.setValue(getValueByCode(tt[10]));

		var admdate = Ext.getCmp("Item10");

		admdate.setValue(getValueByCode(tt[14]));

		var admtime = Ext.getCmp("Item11");

		admtime.setValue(getValueByCode(tt[15]));

		//var Nation = Ext.getCmp("Item8"); //民族

		//Nation.setValue(getValueByCode(tt[18]));

		//	var admreason = Ext.getCmp("Item11"); //费用支付

		//admreason.setValue(getValueByCode(tt[19]));

		var paersonLX = Ext.getCmp("Item9"); //联系人姓名

		paersonLX.setValue(getValueByCode(tt[20]) +"  "+ getValueByCode(tt[29]));

		var Item18 = Ext.getCmp("Item57"); //职业

		Item18.setValue(getValueByCode(tt[21]));

		//var paersonLX = Ext.getCmp("Item21"); //与患者关系

		//	paersonLX.setValue(getValueByCode(tt[22]));

		var paersonLX = Ext.getCmp("Item8"); //婚姻

		paersonLX.setValue(getValueByCode(tt[23]));


		var MedCareNo = Ext.getCmp("Item6");

		MedCareNo.setValue(getValueByCode(tt[9]));

	}

}

function getValueByCode(tempStr)

{

	var retStr = tempStr;

	var strArr = tempStr.split("|");

	if (strArr.length > 1)

	{

		retStr = strArr[1];

	}

	return retStr;

}

function butPrintFn()

{

	PrintCommPic.WebUrl = WebIp + "/dthealth/web/DWR.DoctorRound.cls";

	var getid = document.getElementById('GetId');

	var id = cspRunServerMethod(getid.value, EmrCode, EpisodeID);

	PrintCommPic.ItmName = "DHCNURMouldPGDPrn";

	PrintCommPic.MthArr = "Nur.DHCMoudData:getVal2&id:" + id + "!";

	PrintCommPic.PrintOut();

}