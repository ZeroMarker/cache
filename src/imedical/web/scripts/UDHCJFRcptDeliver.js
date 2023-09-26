var guser;
var SelectedRow = 0;
var maxrowid;
var stno;
var endno;
var judgepass1 = 0;
var judgepass2 = 0;
var type
var type1obj, user1obj;
function BodyLoadHandler() {
	var num = 0;
	//	websys_setTitleBar("OutPatient  Registeration");
	guser = session['LOGON.USERID'];
		var obj = document.getElementById('guser');
	obj.value = guser;

		obj1 = document.getElementById('add');
	if (obj1)
		obj1.onclick = add_Click;

	var numobj = document.getElementById('delivernum');
	if (numobj)
		numobj.onkeyup = celendno;
	document.getElementById('Startno').readOnly = true;
		type1obj = document.getElementById("type");
	type1obj.onkeydown = gettype;
	user1obj = document.getElementById("deliveruser");
	user1obj.onkeydown = getuser;
	
	var obj = document.getElementById('endno');
	if(obj){
		obj.onchange=EndonOnChange;
	}
	//StartNo()
	//query_Click()
}

function StartNo() {
	var obj = document.getElementById('Bezjuserid');
	var Bezjuserid = ""
		if (obj)
			Bezjuserid = obj.value
				type = document.getElementById('type').value
				selectrow = SelectedRow;
		if (Bezjuserid == "") {
			return;
		}
		var getstno = document.getElementById('getstno');
	if (getstno) {
		var encmeth = getstno.value
	} else {
		var encmeth = ''
	};
	if (cspRunServerMethod(encmeth, 'SetNo', '', Bezjuserid, type) == '0') {}
}
function SetNo(value) {
	var str = value;
	var str1 = str.split("^");
	var obj = document.getElementById('Startno');
	obj.value = str1[0];
	obj1 = document.getElementById('endno');
	obj1.value = str1[1];
	obj3 = document.getElementById('kyendno');
	obj3.value = str1[1];
	obj4 = document.getElementById('kyrowid');
	obj4.value = str1[2];

}

function find_Click() {}
function add_Click() {
	judgepass1 = 0;
	judgepass2 = 0;
	var stnoobj = document.getElementById('Startno');
	if (stnoobj)
		var startno = stnoobj.value;
	var endnoobj = document.getElementById('endno');
	if (endnoobj)
		var endno = endnoobj.value;
	
	var oldEndNo = document.getElementById('kyendno').value;
	if(+oldEndNo<+endno){
		alert(t["EndNoMaxErr"]);
		websys_setfocus('endno');
		return;
	}
	
	// var buyuserobj=document.getElementById('guser');
	//if (buyuserobj) var buyuser=buyuserobj.value;
	var pass1obj = document.getElementById('passward1');
	if (pass1obj)
		var pass1 = pass1obj.value;
	var pass2obj = document.getElementById('passward2');
	if (pass2obj)
		var pass2 = pass2obj.value;
	var kyendobj = document.getElementById('kyendno');
	if (kyendobj)
		var kyendno = kyendobj.value;
	var kyrowidobj = document.getElementById('kyrowid');
	if (kyrowidobj)
		var kyrowid = kyrowidobj.value;
	type = document.getElementById('type').value;
	//var userid1=buyuser;
	var useflag = ""
		if (startno == "" || endno == "") {
			alert(t['01']);
			websys_setfocus('endno');
			return false;
		}
		/*
		if (pass1=="") {
		alert(t['02']);
		websys_setfocus('passward1');
		}
		if (pass2=="") {
		alert(t['03']);
		websys_setfocus('passward2');
		}
		 */
		if (!checkno(startno)) {
			alert(t['04']);
			websys_setfocus('Startno');
			return false;
		}
		if (!checkno(endno)) {
			alert(t['05']);
			websys_setfocus('endno');
			return false;
		}
		if (parseInt(endno, 10) < parseInt(startno, 10)) {
			alert(t['06']);
			websys_setfocus('endno');
			return false;
		}
		if (endno.length != startno.length) {
			alert(t['07']);
			websys_setfocus('endno');
			return false;
		}
		var deliveruserObj = document.getElementById('deliveruser');
	if (deliveruserObj) {
		var deliveruser = strTrim(deliveruserObj.value);
		if (deliveruser == "") {
			document.getElementById('zjuserid').value = "";
		}
	}
	var BedeliveruserObj = document.getElementById('Bedeliveruser');
	if (BedeliveruserObj) {
		var Bedeliveruser = strTrim(BedeliveruserObj.value);
		if (Bedeliveruser == "") {
			document.getElementById('Bezjuserid').value = "";
		}
	}
	var userobj = document.getElementById('zjuserid');
	if (userobj)
		var userid = userobj.value;
	if (userid == "") {
		alert(t['08'])
		websys_setfocus('deliveruser');
		return;
	}
	var beuserobj = document.getElementById('Bezjuserid');
	if (beuserobj)
		var beuserid = beuserobj.value;
	if (beuserid == "") {
		alert(t['19']);
		websys_setfocus('Bedeliveruser');
		return;
	}

	if (beuserid == userid) {
		alert("转交人不能与接受人相同,请重新选择接受人");
		return;
	}
	/*
	var strpwd=userid1+"^"+pass1

	var judgepwd=document.getElementById('judgepwd');
	if (judgepwd) {var encmeth=judgepwd.value} else {var encmeth=''};
	if (cspRunServerMethod(encmeth,'judgepwd','',strpwd)=='0'){
	};

	var strpwd1=userid+"^"+pass2
	var judgepwd1=document.getElementById('judgepwd1');
	if (judgepwd1) {var encmeth=judgepwd1.value} else {var encmeth=''};
	if (cspRunServerMethod(encmeth,'judgepwd1','',strpwd1)=='0'){
	};
	 */
	//if (judgepass1==1 & judgepass2==1) {

	var truthBeTold = window.confirm(t['11'] + startno + t['12'] + endno + t['13']);
	if (truthBeTold) {

		//var str="^"+startno+"^"+endno+"^"+userid+"^"+kyendno+"^"+kyrowid+"^"+type

		var str = startno + "^" + endno + "^" + startno + "^" + beuserid + "^" + "" + "^" + userid + "^^" + kyendno + "^" + kyrowid + "^" + type + "^" + guser;
		var err = "";
		p1 = str;
		var HospDr = session['LOGON.HOSPID'];
		var getadd = document.getElementById('getadd');
		if (getadd) {
			var encmeth = getadd.value;
		} else {
			var encmeth = '';
		};
		var rtn = cspRunServerMethod(encmeth, 'addok', '', p1, HospDr);
		if (rtn == "-100") {
			alert("不能重复转交,请重新刷新界面");
		}

	}
	//}

}
function addok(value) {
	if (value == 0) {
		var findobj = document.getElementById('find');
		if (findobj)
			findobj.click();
		//	window.location.reload();
	}
}
function judgepwd(value) {
	if (value == '100') {
		alert(t['09']);
		websys_setfocus('passward1');
		judgepass1 = 0
	} else {
		judgepass1 = 1
	}
}
function judgepwd1(value) {
	if (value == '100') {
		alert(t['10']);
		websys_setfocus('passward2');
		judgepass2 = 0
	} else {
		judgepass2 = 1
	}

}
function celendno() {
	var numobj = document.getElementById('delivernum');
	if (numobj)
		var num = numobj.value
			var snoobj = document.getElementById('Startno');
	if (snoobj)
		var sno = snoobj.value

			var ssno = ""
			var ssno1, slen, sslen

		if (num == "" || (parseInt(num, 10) == 0))
			return;

	if (checkno(num) && (sno != "") && checkno(sno)) {
		ssno1 = parseInt(sno, 10) + parseInt(num, 10) - 1;
		ssno = ssno1.toString()
			slen = sno.length
			sslen = ssno.length
			for (i = slen; i > sslen; i--) {
				ssno = "0" + ssno
			}

			var endnoobj = document.getElementById('endno');
		if (endnoobj)
			endnoobj.value = ssno;
	}
}

function LookUpUser(str) {
	var obj = document.getElementById('zjuserid');
	var tem = str.split("^");
	obj.value = tem[1];

}
function LookUpBeUser(str) {
	var obj = document.getElementById('Bezjuserid');
	var tem = str.split("^");
	obj.value = tem[1];
	StartNo();

}
function checkno(inputtext) {
	var checktext = "1234567890"
		for (var i = 0; i < inputtext.length; i++) {
			var chr = inputtext.charAt(i);
			var indexnum = checktext.indexOf(chr);
			if (indexnum < 0)
				return false;
		}
		return true;
}
function gettype() {
	if (window.event.keyCode == 13) {
		window.event.keyCode = 117;
		type_lookuphandler();
	}
}
function getuser() {
	if (window.event.keyCode == 13) {
		window.event.keyCode = 117;
		deliveruser_lookuphandler();
	}
}

function strTrim(str) {
	return str.replace(/(^\s*)|(\s*$)/g, "");
}
document.body.onload = BodyLoadHandler;