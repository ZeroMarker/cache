///UDHCJFDayPrint.js
var PrtYJInfo, HospitalDesc
GetHospitalDesc();
function printYJ(RepeatPrintFlag, Remark) {
	var patname,
	patno,
	patdep,
	payamt,
	paymode,
	amtdx,
	rcptno
	var prtyear,
	prtmonth,
	prtday,
	prttime,
	username,
	depttypedesc
	var patmedcare
	//var PrintInfo=aa+String.fromCharCode(2)+bb
	patname = subyjinfor[0]
		patno = subyjinfor[1]
		patdep = subyjinfor[9]//病区
		payamt = subyjinfor[3]
		paymode = subyjinfor[4]
		amtdx = subyjinfor[5]
		rcptno = subyjinfor[14]
		prtyear = subyjinfor[20]
		prtmonth = subyjinfor[21]
		prtday = subyjinfor[22]
		prttime = subyjinfor[23]
		username = subyjinfor[24]
		patmedcare = subyjinfor[8]
		patno = patno + "  病案号:" + patmedcare
		PrtYJInfo = "patname" + String.fromCharCode(2) + patname + "^" + "patno" + String.fromCharCode(2) + patno + "^" + "patdep" + String.fromCharCode(2) + patdep;
		PrtYJInfo = PrtYJInfo + "^" + "payamt" + String.fromCharCode(2) + payamt + "^" + "paymode" + String.fromCharCode(2) + paymode + "^" + "amtdx" + String.fromCharCode(2) + amtdx;
		PrtYJInfo = PrtYJInfo + "^" + "rcptno" + String.fromCharCode(2) + rcptno + "^" + "prtyear" + String.fromCharCode(2) + prtyear + "^" + "prtmonth" + String.fromCharCode(2) + prtmonth;
		PrtYJInfo = PrtYJInfo + "^" + "prtday" + String.fromCharCode(2) + prtday + "^" + "prttime" + String.fromCharCode(2) + prttime + "^" + "username" + String.fromCharCode(2) + username;
		//PrtYJInfo = PrtYJInfo + "^" + "djh" + String.fromCharCode(2) + t['dtdjh'] + "^" + "n" + String.fromCharCode(2) + t['dtn'] + "^" + "y" + String.fromCharCode(2) + t['dty'] + "^" + "r" + String.fromCharCode(2) + t['dtr']
		//PrtYJInfo = PrtYJInfo + "^" + "no" + String.fromCharCode(2) + t['dt'] + "^" + "dtzsd" + String.fromCharCode(2) + t['dtzsd'] + "^" + "dtbfbr" + String.fromCharCode(2) + t['dtbfbr'] + "^" + "dtyjzyf" + String.fromCharCode(2) + t['dtyjzyf']
		//PrtYJInfo = PrtYJInfo + "^" + "dtrmb" + String.fromCharCode(2) + t['dtrmb'] + "^" + "dtd" + String.fromCharCode(2) + t['dtd'] + "^" + "dtjsr" + String.fromCharCode(2) + t['dtjsr'] + "^" + "dtz" + String.fromCharCode(2) + Remark
		//PrtYJInfo = PrtYJInfo + "^" + "dtyjjbt" + String.fromCharCode(2) + t['dtyjjbt'] + "^" + "dtfbt" + String.fromCharCode(2) + HospitalDesc + "^" + "RepeatPrintFlag" + String.fromCharCode(2) + RepeatPrintFlag
		PrtYJInfo = PrtYJInfo + "^" + "djh" + String.fromCharCode(2) + "登记号:" + "^" + "n" + String.fromCharCode(2) + "年" + "^" + "y" + String.fromCharCode(2) + "月" + "^" + "r" + String.fromCharCode(2) + "日";
		PrtYJInfo = PrtYJInfo + "^" + "no" + String.fromCharCode(2) + "No:" + "^" + "dtzsd" + String.fromCharCode(2) + "兹收到" + "^" + "dtbfbr" + String.fromCharCode(2) + "病房病人" + "^" + "dtyjzyf" + String.fromCharCode(2) + "预交金计";
		PrtYJInfo = PrtYJInfo + "^" + "dtrmb" + String.fromCharCode(2) + "人民币" + "^" + "dtd" + String.fromCharCode(2) + "￥:" + "^" + "dtjsr" + String.fromCharCode(2) + "经手人:" + "^" + "dtz" + String.fromCharCode(2) + Remark
		PrtYJInfo = PrtYJInfo + "^" + "dtyjjbt" + String.fromCharCode(2) + "住院病人预交金收据" + "^" + "dtfbt" + String.fromCharCode(2) + HospitalDesc + "^" + "RepeatPrintFlag" + String.fromCharCode(2) + RepeatPrintFlag
		var myobj = document.getElementById("ClsBillPrint");
	DHCP_PrintFun(myobj, PrtYJInfo, "");
}
function printYJbak(RepeatPrintFlag, Remark) {
	var PatName,
	PatNo,
	PatWard,
	PatDep,
	PayAmt,
	PayMode,
	PayAmtDX,
	RcptNo
	var PrtYear,
	PrtMonth,
	PrtDay,
	PrtTime,
	UserName,
	DepostiTypeDesc
	var Bank,
	Company,
	BankNo,
	AcountNo //银行，单位，票号，账号
	var PatMedicare,
	AdmDate
	PatName = subyjinfor[0]
		PatNo = subyjinfor[1]
		PatWard = subyjinfor[2]
		PayAmt = subyjinfor[3]
		PayMode = subyjinfor[4]
		PayAmtDX = subyjinfor[5]
		PatDep = subyjinfor[9]
		Bank = subyjinfor[11]
		Company = subyjinfor[12]
		BankNo = subyjinfor[13]
		RcptNo = subyjinfor[14]
		AcountNo = subyjinfor[16]
		PrtDay = subyjinfor[18]
		UserName = subyjinfor[24]
		PatMedicare = subyjinfor[8]
		AdmDate = subyjinfor[10]
		PrtYJInfo = "PatName" + String.fromCharCode(2) + PatName + "^" + "PatNo" + String.fromCharCode(2) + PatNo + "^" + "PatMedicare" + String.fromCharCode(2) + PatMedicare
		PrtYJInfo = PrtYJInfo + "^" + "PatWard" + String.fromCharCode(2) + PatWard + "^" + "PatDep" + String.fromCharCode(2) + PatDep + "^" + "PrtDay" + String.fromCharCode(2) + PrtDay
		PrtYJInfo = PrtYJInfo + "^" + "PayMode" + String.fromCharCode(2) + PayMode + "^" + "PayAmt" + String.fromCharCode(2) + PayAmt + "^" + "PayAmtDX" + String.fromCharCode(2) + PayAmtDX
		PrtYJInfo = PrtYJInfo + "^" + "Bank" + String.fromCharCode(2) + Bank + "^" + "Company" + String.fromCharCode(2) + Company + "^" + "BankNo" + String.fromCharCode(2) + BankNo

		PrtYJInfo = PrtYJInfo + "^" + "AcountNo" + String.fromCharCode(2) + AcountNo + "^" + "AdmDate" + String.fromCharCode(2) + AdmDate + "^" + "UserName" + String.fromCharCode(2) + UserName
		var myobj = document.getElementById("ClsBillPrint");
	DHCP_PrintFun(myobj, PrtYJInfo, "");
}

/*function printYJ(){dtfbt
CommonPrint('UDHCJFDepositPrt')
}*/

function printDayDetail(p1, p2) {
	var xlApp,
	obook,
	osheet,
	xlsheet,
	xlBook,
	temp,
	str,
	vbdata,
	i,
	j
	var Template
	var k = 0,
	l
	var pagerows,
	pagenum,
	prtrow
	pagerows = 1

		if (pagerows == 1) {
			Template = path + "JF_Detail.xls"
		} else {
			Template = path + "JF_Detail1.xls"
		}
		xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(Template);
	xlsheet = xlBook.ActiveSheet
		//xlApp.visible=true
		var prtrows,
	patname,
	patno
	prtrows = 2
		GetHospitalDesc()
		// xlsheet.cells(2,1).value=HospitalDesc+"日清明细单"

		for (k = 0; k < patcount; k++) {
			var gnum = 0,
			j
			p4 = patstr[k]
				var tempreg = "^" + p4 + "^"

				if (tmppat == "^")
					continue;
				if (tmppat.indexOf(tempreg) == "-1")
					continue;

				var getnum = document.getElementById('getnum');
			if (getnum) {
				var encmeth = getnum.value
			} else {
				var encmeth = ''
			};

			gnum = cspRunServerMethod(encmeth, '', '', p1, p2, p4, Guser);

			if (pagerows == 1) {
				prtrows = prtrows + 1
					for (i = 1; i <= gnum - 1; i++) {
						p3 = i
							var getdata = document.getElementById('getdata');
						if (getdata) {
							var encmeth = getdata.value
						} else {
							var encmeth = ''
						};
						var str = cspRunServerMethod(encmeth, '', '', p1, p2, p4, p3, Guser);
						myData1 = str.split("^")

							if (i == 1) {
								patname = myData1[8]
									patno = myData1[7]
									var deposit,
								patfee,
								remain
								deposit = myData1[9]
									patfee = myData1[10]
									remain = myData1[11]
									warddesc = myData1[15]
									//prtrows=prtrows+1

									xlsheet.cells(prtrows, 1).value = HospitalDesc + "日清明细单"
									xlsheet.range(xlsheet.cells(prtrows, 1), xlsheet.cells(prtrows - 1, 15)).Font.Bold = true;
								xlsheet.Range(xlsheet.Cells(prtrows, 1), xlsheet.Cells(prtrows, 15)).MergeCells = 1; //合并单元格
								// xlsheet.range(xlsheet.cells(prtrows,1),xlsheet.cells(prtrows-1,15)).Font.Sise=13
								var PrtRange = "A" + prtrows + ":" + "O" + prtrows
									xlsheet.Range(PrtRange).HorizontalAlignment = 3

									prtrows = prtrows + 2
									xlsheet.cells(prtrows, 1) = t['01'] + warddesc + "  预缴金: " + deposit + t['06'] + patfee + t['07'] + remain
									xlsheet.range(xlsheet.cells(prtrows, 1), xlsheet.cells(prtrows, 15)).Font.Bold = true;
								xlsheet.range(xlsheet.cells(prtrows, 1), xlsheet.cells(prtrows, 15)).Borders(4).LineStyle = 1
									prtrows = prtrows + 1
									xlsheet.Cells(prtrows, 1) = "姓名: " + patname + " 登记号: " + patno + t['04'] + fromdate + "--" + todate
									xlsheet.range(xlsheet.cells(prtrows, 1), xlsheet.cells(prtrows, 15)).Font.Bold = true;
								xlsheet.range(xlsheet.cells(prtrows, 1), xlsheet.cells(prtrows, 15)).Borders(4).LineStyle = 1
									prtrows = prtrows + 1
									xlsheet.cells(prtrows, 1) = t['08']
									xlsheet.cells(prtrows, 2) = t['09']
									xlsheet.cells(prtrows, 3) = t['10']
									xlsheet.cells(prtrows, 4) = t['11']
									xlsheet.cells(prtrows, 5) = t['12']
									xlsheet.cells(prtrows, 6) = t['13']
									//xlsheet.cells(prtrows,14)="分类"
									xlsheet.cells(prtrows, 15) = "物价编码"
									xlsheet.range(xlsheet.cells(prtrows, 1), xlsheet.cells(prtrows, 15)).Font.Bold = true;
								xlsheet.range(xlsheet.cells(prtrows, 1), xlsheet.cells(prtrows, 15)).Borders(4).LineStyle = 1
									prtrows = prtrows + 1
							}
							for (j = 0; j < 15; j++) {
								
								if((j<6)||(j==14)){
									
									xlsheet.cells(prtrows, j + 1) = myData1[j]
								}
									if ((myData1[j] == "小计") || (myData1[j] == "总计")) {
										xlsheet.range(xlsheet.cells(prtrows, 1), xlsheet.cells(prtrows, 15)).Font.Bold = true;
										xlsheet.range(xlsheet.cells(prtrows, 1), xlsheet.cells(prtrows, 15)).Borders(4).LineStyle = 1
									}
							}
							prtrows = prtrows + 1
					}
			}
			if (pagerows == 2) {
				var pagenum,
				lastnum,
				rownum
				var rows = gnum
					if ((rows % pagerows) == 0) {
						pagenum = Math.floor(rows / pagerows)
					} else {
						pagenum = Math.floor(rows / pagerows) + 1
					}
					var lastnum = rows - (pagenum - 1) * pagerows

					var str = new Array();
				var n = 0,
				j,
				i
				for (l = 1; l <= pagenum; l++) { //alert(prtrows)
					if (l == pagenum) {
						rownum = lastnum
					} else {
						rownum = pagerows
					}
					for (i = 0; i < rownum; i++) {
						var currprintrw = (l - 1) * pagerows + i + 1
						p3 = currprintrw
							var getdata = document.getElementById('getdata');
						if (getdata) {
							var encmeth = getdata.value
						} else {
							var encmeth = ''
						};
						var str = cspRunServerMethod(encmeth, '', '', p1, p2, p4, p3);
						myData1 = str.split("^")

							if (currprintrw == 1) {
								patname = myData1[8]
									patno = myData1[7]
									var deposit,
								patfee,
								remain
								deposit = myData1[9]
									patfee = myData1[10]
									remain = myData1[11]
									prtrows = prtrows + 1
									xlsheet.cells(prtrows, 2) = t['01'] + warddesc + t['02'] + patname + t['03'] + patno + t['04'] + fromdate + "--" + todate
									prtrows = prtrows + 1
									xlsheet.Cells(prtrows, 2) = t['05'] + deposit + t['06'] + patfee + t['07'] + remain
									prtrows = prtrows + 1
									xlsheet.cells(prtrows, 2) = t['09']
									xlsheet.cells(prtrows, 3) = t['10']
									xlsheet.cells(prtrows, 4) = t['12']
									xlsheet.cells(prtrows, 5) = t['13']
									xlsheet.cells(prtrows, 7) = t['09']
									xlsheet.cells(prtrows, 8) = t['10']
									xlsheet.cells(prtrows, 9) = t['12']
									xlsheet.cells(prtrows, 10) = t['13']
									prtrows = prtrows + 1
							}
							if (currprintrw != gnum) {
								if (i > 0) {
									xlsheet.Cells(prtrows, 7) = myData1[1]
										xlsheet.Cells(prtrows, 8) = myData1[2]
										xlsheet.Cells(prtrows, 9) = myData1[4]
										xlsheet.Cells(prtrows, 10) = myData1[5]
								} else {
									xlsheet.Cells(prtrows, 2) = myData1[1]
										xlsheet.Cells(prtrows, 3) = myData1[2]
										xlsheet.Cells(prtrows, 4) = myData1[4]
										xlsheet.Cells(prtrows, 5) = myData1[5]
										if (myData1[1] == t['14']) {
											prtrows = prtrows + 1
										}
								}
							}
					}

					prtrows = prtrows + 1
				}

			}

			//add by wangjian 2015-01-26
			var myCondition = '{ward:"' + p2 + '",papno:"' + p4 + '",Guser:"' + Guser + '"}'
				var myContent = '{papno:"' + p4 + '",date:"' + todate + '"}'
				var PAPMIID = tkMakeServerCall("web.UDHCJFIPReg", "GetPapmiId", p4, "")
				var mySecretCodeStr = tkMakeServerCall("web.UDHCJFBaseCommon", "GetPatEncryptLevel", PAPMIID, "")
				var mySecretCode = mySecretCodeStr.split("^")[2];
			websys_EventLog("UDHCJFDayDetail.printDayDetail", myCondition, myContent, mySecretCode);
			//end
		} //for k

		xlsheet.printout
		//xlApp.Visible=true
		//xlsheet.PrintPreview();

		xlBook.Close(savechanges = false);
	xlApp.Quit();
	xlApp = null;
	xlsheet = null
}
function printDayDetailSplit(p1, p2) {

	var xlApp,
	obook,
	osheet,
	xlsheet,
	xlBook,
	temp,
	str,
	vbdata,
	i,
	j
	var Template
	var k = 0,
	l
	var pagerows,
	pagenum,
	prtrow
	pagerows = 1

		if (pagerows == 1) {
			Template = path + "JF_DetailSplit.xls"
		} else {
			Template = path + "JF_Detail1.xls"
		}
		xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(Template);
	xlsheet = xlBook.ActiveSheet
		//xlApp.visible=true
		var prtrows,
	patname,
	patno
	prtrows = 2
		GetHospitalDesc()
		// xlsheet.cells(2,1).value=HospitalDesc+"日清明细单"

		for (k = 0; k < patcount; k++) {
			var gnum = 0,
			j
			p4 = patstr[k]
				var tempreg = "^" + p4 + "^"

				if (tmppat == "^")
					continue;
				if (tmppat.indexOf(tempreg) == "-1")
					continue;

				var getnum = document.getElementById('getnum');
			if (getnum) {
				var encmeth = getnum.value
			} else {
				var encmeth = ''
			};

			gnum = cspRunServerMethod(encmeth, '', '', p1, p2, p4, Guser);

			if (pagerows == 1) {
				prtrows = prtrows + 1
					for (i = 1; i <= gnum - 1; i++) {
						p3 = i
							var getdata = document.getElementById('getdata');
						if (getdata) {
							var encmeth = getdata.value
						} else {
							var encmeth = ''
						};
						var str = cspRunServerMethod(encmeth, '', '', p1, p2, p4, p3, Guser);
						myData1 = str.split("^")

							if (i == 1) {
								patno = myData1[10]
									patname = myData1[11]
									var deposit,
								patfee,
								remain
								deposit = myData1[12]
									patfee = myData1[13]
									remain = myData1[14]
									warddesc = myData1[17]
									//prtrows=prtrows+1

									xlsheet.cells(prtrows, 1).value = HospitalDesc + "日清明细单"
									xlsheet.range(xlsheet.cells(prtrows, 1), xlsheet.cells(prtrows - 1, 9)).Font.Bold = true;
								xlsheet.Range(xlsheet.Cells(prtrows, 1), xlsheet.Cells(prtrows, 9)).MergeCells = 1; //合并单元格
								// xlsheet.range(xlsheet.cells(prtrows,1),xlsheet.cells(prtrows-1,15)).Font.Sise=13
								var PrtRange = "A" + prtrows + ":" + "O" + prtrows
									xlsheet.Range(PrtRange).HorizontalAlignment = 3

									prtrows = prtrows + 2
									xlsheet.cells(prtrows, 1) = t['01'] + warddesc + "  预缴金: " + deposit + t['06'] + patfee + t['07'] + remain
									xlsheet.Range(xlsheet.Cells(prtrows, 1), xlsheet.Cells(prtrows, 9)).MergeCells = 1; //合并单元格
									xlsheet.range(xlsheet.cells(prtrows, 1), xlsheet.cells(prtrows, 9)).Font.Bold = true;
								xlsheet.range(xlsheet.cells(prtrows, 1), xlsheet.cells(prtrows, 9)).Borders(4).LineStyle = 1
									prtrows = prtrows + 1
									xlsheet.Cells(prtrows, 1) = "姓名: " + patname + " 登记号: " + patno + t['04'] + fromdate + "--" + todate
									xlsheet.range(xlsheet.cells(prtrows, 1), xlsheet.cells(prtrows, 9)).Font.Bold = true;
								xlsheet.range(xlsheet.cells(prtrows, 1), xlsheet.cells(prtrows, 9)).Borders(4).LineStyle = 1
								xlsheet.Range(xlsheet.Cells(prtrows, 1), xlsheet.Cells(prtrows, 9)).MergeCells = 1
									prtrows = prtrows + 1
									xlsheet.cells(prtrows, 1) = t['08']
									xlsheet.cells(prtrows, 2) = t['09']
									xlsheet.cells(prtrows, 3) = t['10']
									xlsheet.cells(prtrows, 4) = t['11']
									xlsheet.cells(prtrows, 5) = t['12']
									xlsheet.cells(prtrows, 6) = t['13']
									xlsheet.cells(prtrows, 7) = "记账日期"
									xlsheet.cells(prtrows, 8) = "记账时间"
									//xlsheet.cells(prtrows,14)="分类"
									xlsheet.cells(prtrows, 9) = "物价编码"
									xlsheet.range(xlsheet.cells(prtrows, 1), xlsheet.cells(prtrows, 9)).Font.Bold = true;
								xlsheet.range(xlsheet.cells(prtrows, 1), xlsheet.cells(prtrows, 9)).Borders(4).LineStyle = 1
									prtrows = prtrows + 1
							}
							for (j = 0; j < 9; j++) {

								xlsheet.cells(prtrows, j + 1) = myData1[j]

									if ((myData1[j] == "小计") || (myData1[j] == "总计")) {

										xlsheet.range(xlsheet.cells(prtrows, 1), xlsheet.cells(prtrows, 9)).Font.Bold = true;
										xlsheet.range(xlsheet.cells(prtrows, 1), xlsheet.cells(prtrows, 9)).Borders(4).LineStyle = 1
									}
							}
							prtrows = prtrows + 1
					}
			}
			if (pagerows == 2) {
				var pagenum,
				lastnum,
				rownum
				var rows = gnum
					if ((rows % pagerows) == 0) {
						pagenum = Math.floor(rows / pagerows)
					} else {
						pagenum = Math.floor(rows / pagerows) + 1
					}
					var lastnum = rows - (pagenum - 1) * pagerows

					var str = new Array();
				var n = 0,
				j,
				i
				for (l = 1; l <= pagenum; l++) { //alert(prtrows)
					if (l == pagenum) {
						rownum = lastnum
					} else {
						rownum = pagerows
					}
					for (i = 0; i < rownum; i++) {
						var currprintrw = (l - 1) * pagerows + i + 1
						p3 = currprintrw
							var getdata = document.getElementById('getdata');
						if (getdata) {
							var encmeth = getdata.value
						} else {
							var encmeth = ''
						};
						var str = cspRunServerMethod(encmeth, '', '', p1, p2, p4, p3);
						myData1 = str.split("^")

							if (currprintrw == 1) {
								patname = myData1[8]
									patno = myData1[7]
									var deposit,
								patfee,
								remain
								deposit = myData1[9]
									patfee = myData1[10]
									remain = myData1[11]
									prtrows = prtrows + 1
									xlsheet.cells(prtrows, 2) = t['01'] + warddesc + t['02'] + patname + t['03'] + patno + t['04'] + fromdate + "--" + todate
									prtrows = prtrows + 1
									xlsheet.Cells(prtrows, 2) = t['05'] + deposit + t['06'] + patfee + t['07'] + remain
									prtrows = prtrows + 1
									xlsheet.cells(prtrows, 2) = t['09']
									xlsheet.cells(prtrows, 3) = t['10']
									xlsheet.cells(prtrows, 4) = t['12']
									xlsheet.cells(prtrows, 5) = t['13']
									xlsheet.cells(prtrows, 7) = t['09']
									xlsheet.cells(prtrows, 8) = t['10']
									xlsheet.cells(prtrows, 9) = t['12']
									xlsheet.cells(prtrows, 10) = t['13']
									prtrows = prtrows + 1
							}
							if (currprintrw != gnum) {
								if (i > 0) {
									xlsheet.Cells(prtrows, 7) = myData1[1]
										xlsheet.Cells(prtrows, 8) = myData1[2]
										xlsheet.Cells(prtrows, 9) = myData1[4]
										xlsheet.Cells(prtrows, 10) = myData1[5]
								} else {
									xlsheet.Cells(prtrows, 2) = myData1[1]
										xlsheet.Cells(prtrows, 3) = myData1[2]
										xlsheet.Cells(prtrows, 4) = myData1[4]
										xlsheet.Cells(prtrows, 5) = myData1[5]
										if (myData1[1] == t['14']) {
											prtrows = prtrows + 1
										}
								}
							}
					}

					prtrows = prtrows + 1
				}

			}

			//add by wangjian 2015-01-26
			var myCondition = '{ward:"' + p2 + '",papno:"' + p4 + '",Guser:"' + Guser + '"}'
				var myContent = '{papno:"' + p4 + '",date:"' + todate + '"}'
				var PAPMIID = tkMakeServerCall("web.UDHCJFIPReg", "GetPapmiId", p4, "")
				var mySecretCodeStr = tkMakeServerCall("web.UDHCJFBaseCommon", "GetPatEncryptLevel", PAPMIID, "")
				var mySecretCode = mySecretCodeStr.split("^")[2];
			websys_EventLog("UDHCJFDayDetail.printDayDetail", myCondition, myContent, mySecretCode);
			//end
		} //for k

		xlsheet.printout
		//xlApp.Visible=true
		//xlsheet.PrintPreview();

		xlBook.Close(savechanges = false);
	xlApp.Quit();
	xlApp = null;
	xlsheet = null
}
/*
function  PrintBillDetail(){
var xlApp,obook,osheet,xlsheet,xlBook,temp,str,vbdata,i,j
var Template

//Template=path+"JF_BillDetailnyfy.xls"
Template="D:\\JF_BillDetailnyfy.xls"
xlApp = new ActiveXObject("Excel.Application");
xlBook = xlApp.Workbooks.Add(Template);
xlsheet = xlBook.ActiveSheet
var objtbl=document.getElementById('tUDHCJFBillDetail');
for (j=1;j<objtbl.rows(0).cells.length;j++)   ///{
xlsheet.cells(5,j)=objtbl.rows(0).cells(j).innerText
}

for (i=1;i<=num;i++){ var str=ListPrt(i)
str=str.split("^")
for (j=1;j<7;j++){xlsheet.cells(i+5,j)=str[j-1]
}
}
str=tmpstr.split("^")
xlsheet.cells(2,2).value=hospital+t['01']
xlsheet.cells(3,2).value=t['01']+":"+str[0]+"  "+t['02']+":"+str[1]+"   "+t['03']+":"+str[5]
//xlsheet.cells(3,4).value=str[0]
//xlsheet.cells(3,6).value=str[6]
xlsheet.cells(4,2).value=t['04']+":"+str[7]+"   "+t['05']+":"+str[8]+"   "+t['06']+":"+str[11]
//xlsheet.cells(4,4).value=str[8]
//xlsheet.cells(4,6).value=str[11]+t['02']

xlsheet.printout
xlBook.Close (savechanges=false);
xlApp.Quit();
xlApp=null;
xlsheet=null
}
 */
function PrintFPbak(PrtRowid) {
	var PrintInfo = document.getElementById('GetPrintInfo');
	if (PrintInfo) {
		var encmeth = PrintInfo.value
	} else {
		var encmeth = ''
	};
	var PrintInfostr = cspRunServerMethod(encmeth, PrtRowid)
		var myobj = document.getElementById("ClsBillPrint");
	DHCP_PrintFun(myobj, PrintInfostr, "");
}
function PrintFP(PrtRowid) {
	var reprintflag = "" //增加补打标志
		var invprtrowid = PrtRowid.split("#")[0]
		var reprintflag = PrtRowid.split("#")[1]
		var PrintInfo = document.getElementById('GetPrintInfo');
	if (PrintInfo) {
		var encmeth = PrintInfo.value
	} else {
		var encmeth = ''
	};
	var PrintInfostr = cspRunServerMethod(encmeth, invprtrowid, "", reprintflag)
		var myobj = document.getElementById("ClsBillPrint");
	DHCP_PrintFun(myobj, PrintInfostr, "");
}
function AdmInfoPrint(patinfo) {
	var xlApp,
	obook,
	osheet,
	xlsheet,
	xlBook
	var patname,
	patno,
	patdw,
	paymode,
	payamt,
	payamtdx,
	temp
	var path,
	dep,
	patdep,
	depname,
	admdate,
	admdate1,
	admdate2
	var sexdesc,
	telph,
	maritaldesc,
	admage,
	address
	var cardno,
	workst,
	depcode
	var getpath = document.getElementById('getpath');
	if (getpath) {
		var encmeth = getpath.value
	} else {
		var encmeth = ''
	};

	path = cspRunServerMethod(encmeth, '', '');
	Template = path + "JF_AdmitInfo.xls";
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(Template);
	xlsheet = xlBook.ActiveSheet;
	para = patinfo.split("^");
	patname = para[1];
	patno = para[0];
	admdate1 = para[2];
	admdate2 = admdate1.split("-");
	admdate = admdate2[0] + t['58'] + admdate2[1] + t['59'] + admdate2[2] + t['60'];
	sexdesc = para[3];
	telph = para[4];
	maritaldesc = para[5];
	admage = para[6];
	address = para[7];
	cardno = para[8];
	workst = para[9];
	depname = para[10];
	xlsheet.cells(3, 7).value = cardno;
	xlsheet.cells(5, 2).value = workst;
	xlsheet.cells(4, 2).value = patname;
	xlsheet.cells(2, 7).value = patno;
	xlsheet.cells(3, 2).value = depname;
	xlsheet.cells(4, 4).value = sexdesc;
	xlsheet.cells(4, 6).value = admage;
	xlsheet.cells(4, 8).value = maritaldesc;
	xlsheet.cells(5, 8).value = "";
	xlsheet.cells(6, 2).value = address;
	xlsheet.cells(6, 8).value = telph;
	xlsheet.cells(7, 2).value = admdate;
	xlsheet.printout;
	xlBook.Close(savechanges = false);
	xlApp = null;
	xlsheet = null;
}
function PrintSubFee() {
	var jstfp,
	fp
	var p1
	var sum = 0
		var ret
		var subdata
		var subdata1 = new Array();
	var subdata2 = new Array();
	var subdata3 = new Array();
	var printinvno

	gusercode = GuserCode
		qita = 0.00
		jstfp = t['fp']
		fp = jstfp.split("_")

		if (BillNo == "") {
			alert(t['01']);
			return;
		}
		var getpath = document.getElementById('getpath');
	if (getpath) {
		var encmeth = getpath.value
	} else {
		var encmeth = ''
	};
	var path = cspRunServerMethod(encmeth, '', '');
	var Template = path + "JF_Print.xls";
	var xlApp = new ActiveXObject("Excel.Application");
	var xlBook = xlApp.Workbooks.Add(Template);
	var xlsheet = xlBook.ActiveSheet;
	p1 = BillNo

		var getinpatsubcate = document.getElementById('getinpatsubcate');
	if (getinpatsubcate) {
		var encmeth = getinpatsubcate.value
	} else {
		var encmeth = ''
	};
	ret = cspRunServerMethod(encmeth, p1);

	subdata = ret.split("##");
	subdata1 = subdata[0].split("^");
	subdata2 = subdata[1].split("@");
	xlsheet.cells(2, 6).value = subdata1[11]//zhuyuanhao
		xlsheet.cells(2, 8).value = subdata1[5]//NAME
		xlsheet.cells(3, 6).value = subdata1[18]//zyno
		xlsheet.cells(3, 8).value = subdata1[22]//shenfenzheng
		xlsheet.cells(3, 11).value = subdata1[21]//ward
		xlsheet.cells(4, 3).value = subdata1[16]//CUR
		xlsheet.cells(4, 5).value = subdata1[8]//RYDATE
		xlsheet.cells(4, 7).value = subdata1[9]//CYDATE
		xlsheet.cells(4, 10).value = subdata1[10]//tianshu
		xlsheet.cells(11, 8).value = subdata2[2]//DAXIE
		xlsheet.cells(11, 4).value = subdata2[1]//XIAOXIE
		xlsheet.cells(12, 3).value = subdata1[4]//DEPOSIT
		xlsheet.cells(19, 3).value = gusercode
		xlsheet.cells(19, 6).value = subdata1[20]
		if (subdata1[0] > 0) {
			xlsheet.cells(12, 5).value = subdata1[0]
		} else {
			xlsheet.cells(13, 5).value = Math.abs(eval(subdata1[0]))
		}
		if (subdata1[1] > 0) {
			xlsheet.cells(12, 7).value = subdata1[1]
		} else {
			xlsheet.cells(13, 7).value = Math.abs(eval(subdata1[1]))
		}
		if (subdata1[2] > 0) {
			xlsheet.cells(12, 9).value = subdata1[2]
		} else {
			xlsheet.cells(13, 9).value = Math.abs(eval(subdata1[2]))
		}
		if (subdata1[3] > 0) {
			xlsheet.cells(14, 5).value = subdata1[3]
		} else {
			xlsheet.cells(14, 7).value = Math.abs(eval(subdata1[3]))
		}
		if (subdata1[17] < 0) {
			xlsheet.cells(12, 11).value = subdata1[17]
		} else {
			xlsheet.cells(13, 11).value = Math.abs(eval(subdata1[17]))
		}
		xlsheet.cells(14, 9).value = Math.abs(eval(subdata1[19])) //qf
		xlsheet.cells(2, 4).value = subdata1[15]
		var subdata4 = subdata2[0].split("&");
	for (i = 1; i < subdata4.length; i++) {
		var tmpstrs = subdata4[i];
		subdata3[i - 1] = tmpstrs.split("^");
	}
	var a = 0
		for (i = 0; i < subdata3.length; i++) {
			switch (subdata3[i][1]) {
			case fp[0]:
				if (subdata3[i][2] != "0.00") {
					xlsheet.cells(6, 3).value = subdata3[i][2]
				}
				a = eval(a) + eval(subdata3[i][2])
					break;
			case fp[1]:
				if (subdata3[i][2] != "0.00") {
					xlsheet.cells(6, 5).value = subdata3[i][2]
				}
				a = eval(a) + eval(subdata3[i][2])
					break;
			case fp[2]:
				if (subdata3[i][2] != "0.00") {
					xlsheet.cells(6, 7).value = subdata3[i][2]
				}
				a = eval(a) + eval(subdata3[i][2])
					break;
			case fp[3]:
				if (subdata3[i][2] != "0.00") {
					xlsheet.cells(6, 9).value = subdata3[i][2]
				}
				a = eval(a) + eval(subdata3[i][2])
					break;
			case fp[4]:
				if (subdata3[i][2] != "0.00") {
					xlsheet.cells(6, 11).value = subdata3[i][2]
				}
				a = eval(a) + eval(subdata3[i][2])
					break;
			case fp[5]:
				if (subdata3[i][2] != "0.00") {
					xlsheet.cells(7, 3).value = subdata3[i][2]
				}
				a = eval(a) + eval(subdata3[i][2])
					break;
			case fp[6]:
				if (subdata3[i][2] != "0.00") {
					xlsheet.cells(7, 5).value = subdata3[i][2]
				}
				a = eval(a) + eval(subdata3[i][2])
					break;
			case fp[7]:
				if (subdata3[i][2] != "0.00") {
					xlsheet.cells(7, 7).value = subdata3[i][2]
				}
				a = eval(a) + eval(subdata3[i][2])
					break;
			case fp[8]:
				if (subdata3[i][2] != "0.00") {
					xlsheet.cells(7, 9).value = subdata3[i][2]
				}
				a = eval(a) + eval(subdata3[i][2])
					break;
			case fp[9]:
				if (subdata3[i][2] != "0.00") {
					xlsheet.cells(7, 11).value = subdata3[i][2]
				}
				a = eval(a) + eval(subdata3[i][2])
					break;
			case fp[10]:
				if (subdata3[i][2] != "0.00") {
					xlsheet.cells(8, 3).value = subdata3[i][2]
				}
				a = eval(a) + eval(subdata3[i][2])
					break;
			case fp[11]:
				if (subdata3[i][2] != "0.00") {
					xlsheet.cells(8, 5).value = subdata3[i][2]
				}
				a = eval(a) + eval(subdata3[i][2])
					break;
			case fp[12]:
				if (subdata3[i][2] != "0.00") {
					xlsheet.cells(8, 7).value = subdata3[i][2]
				}
				a = eval(a) + eval(subdata3[i][2])
					break;
			case fp[13]:
				if (subdata3[i][2] != "0.00") {
					xlsheet.cells(8, 9).value = subdata3[i][2]
				}
				a = eval(a) + eval(subdata3[i][2])
					break;
			case fp[14]:
				if (subdata3[i][2] != "0.00") {
					xlsheet.cells(8, 11).value = subdata3[i][2]
				}
				a = eval(a) + eval(subdata3[i][2])
					break;
			case fp[15]:
				if (subdata3[i][2] != "0.00") {
					xlsheet.cells(9, 3).value = subdata3[i][2]
				}
				a = eval(a) + eval(subdata3[i][2])
					break;
			case fp[16]:
				if (subdata3[i][2] != "0.00") {
					xlsheet.cells(9, 5).value = subdata3[i][2]
				}
				a = eval(a) + eval(subdata3[i][2])
					break;
			case fp[17]:
				if (subdata3[i][2] != "0.00") {
					xlsheet.cells(9, 7).value = subdata3[i][2]
				}
				a = eval(a) + eval(subdata3[i][2])
					break;
			case fp[18]:
				if (subdata3[i][2] != "0.00") {
					xlsheet.cells(9, 9).value = subdata3[i][2]
				}
				a = eval(a) + eval(subdata3[i][2])
					break;
			case fp[19]:
				if (subdata3[i][2] != "0.00") {
					xlsheet.cells(9, 11).value = subdata3[i][2]
				}
				a = eval(a) + eval(subdata3[i][2])
					break;
			case fp[20]:
				if (subdata3[i][2] != "0.00") {
					xlsheet.cells(10, 3).value = subdata3[i][2]
				}
				a = eval(a) + eval(subdata3[i][2])
					break;
			case fp[21]:
				if (subdata3[i][2] != "0.00") {
					xlsheet.cells(10, 5).value = subdata3[i][2]
				}
				a = eval(a) + eval(subdata3[i][2])
					break;
			case fp[22]:
				if (subdata3[i][2] != "0.00") {
					xlsheet.cells(10, 7).value = subdata3[i][2]
				}
				a = eval(a) + eval(subdata3[i][2])
					break;
			case fp[23]:
				if (subdata3[i][2] != "0.00") {
					xlsheet.cells(10, 9).value = subdata3[i][2]
				}
				a = eval(a) + eval(subdata3[i][2])
					break;
			case fp[24]:
				qita = eval(qita) + eval(subdata3[i][2])
					a = eval(a) + eval(subdata3[i][2])
					break;
			default:
				if (subdata3[i][2] != "0.00") {
					qita = eval(qita) + eval(subdata3[i][2])
				}
				break;
			}
		}
		qita = qita.toFixed(2)
		if (qita != 0) {
			xlsheet.cells(10, 11).value = qita
		}
		xlApp.Visible = true
		xlsheet.PrintPreview();
	xlBook.Close(savechanges = false);
	xlApp.Quit();
	xlApp = null;
	xlsheet = null
}
function PrintTZclick() {
	if (BillNo == "") {
		alert(t['01'])
		return;
	} else {
		CommonPrint('UDHCJFIPTZ')
	}

}
///描述:     医嘱费用明细打印
///编写者:   陈曦
///编写日期: 2009.02.12
function PrtOrdDetail(job, PrtOrdDetailNum) {
	if (job == "") {
		return;
	}
	if (eval(PrtOrdDetailNum) < 0) {
		return;
	}
	var xlApp,
	obook,
	osheet,
	xlsheet,
	xlBook,
	temp,
	str,
	vbdata,
	i,
	j
	var Template
	var k = 0,
	l
	var pagerows,
	pagenum,
	prtrow

	pagerows = 2
		if (pagerows == 1) {
			Template = path + "DHCIPBill_OrdDetail.xls"
		} else {
			Template = path + "DHCIPBill_OrdDetail1.xls"
		}

		xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(Template);
	xlsheet = xlBook.ActiveSheet
		GetHospitalDesc()
		xlsheet.cells(2, 1).value = HospitalDesc + "医嘱费用明细单"
		if (pagerows == 2) {
			k = 0
				j = 0
				for (i = 1; i <= PrtOrdDetailNum; i++) {
					var PrtOrdDetailStr = ListPrtOrdDetail(job, i)
						var PrtOrdDetailStr1 = PrtOrdDetailStr.split("^")
						var datestr1 = ""
						if (PrtOrdDetailStr[1] != "") {
							if (PrtOrdDetailStr1[1] != "") {
								var datestr = PrtOrdDetailStr1[1].split("-")
									datestr1 = datestr[1] + "." + datestr[2]
							}
						}
						if (j == 0) {
							xlsheet.cells(k + 6, 1).value = datestr1
								xlsheet.cells(k + 6, 2).value = PrtOrdDetailStr1[0]
								xlsheet.cells(k + 6, 5).value = PrtOrdDetailStr1[3]
								xlsheet.cells(k + 6, 6).value = PrtOrdDetailStr1[7]
								j = 1
								if (PrtOrdDetailStr1[0] == t['PrtOrdDetail01']) {
									j = 0
										k = k + 1
								}
								continue;
						}
						if (j == 1) {
							n = 7
								if (PrtOrdDetailStr1[0] == t['PrtOrdDetail01']) {
									k = k + 1
										n = 0
								}
								xlsheet.cells(k + 6, n + 1).value = datestr1
								xlsheet.cells(k + 6, n + 2).value = PrtOrdDetailStr1[0]
								xlsheet.cells(k + 6, n + 5).value = PrtOrdDetailStr1[3]
								xlsheet.cells(k + 6, n + 6).value = PrtOrdDetailStr1[7]
								j = 0
								k = k + 1
								continue;
						}
				}
		}
		xlsheet.cells(4, 5).value = regnoobj.value
		xlsheet.cells(4, 2).value = nameobj.value
		xlsheet.printout
		//xlsheet.PrintPreview();
		xlBook.Close(savechanges = false);
	xlApp.Quit();
	xlApp = null;
	xlsheet = null
}
///描述:     补打押金收据
///编写者:   李超
///编写日期: 2009.02.09
function ReprintYJ() { //JST DEPOSIT PRINT  yyx 2006-11-08
	var xlApp,
	obook,
	osheet,
	xlsheet,
	xlBook
	Template = path + "JF_DepositRe.xls";
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(Template);
	xlsheet = xlBook.ActiveSheet;
	var sub = returnval.split("^")
		xlsheet.cells(3, 6).value = sub[14]
		xlsheet.cells(4, 3).value = sub[1]
		xlsheet.cells(5, 3).value = sub[8]//20
		xlsheet.cells(4, 6).value = sub[0]
		xlsheet.cells(6, 3).value = sub[10]
		xlsheet.cells(5, 6).value = sub[2]
		xlsheet.cells(7, 3).value = sub[5]
		xlsheet.cells(6, 6).value = sub[9]
		xlsheet.cells(8, 3).value = sub[11]
		xlsheet.cells(8, 6).value = sub[20]
		xlsheet.cells(12, 3).value = sub[18]
		xlsheet.cells(12, 5).value = session['LOGON.USERCODE']
		if (sub[3] > 0) {
			xlsheet.cells(7, 6).value = t['jst01']
				xlsheet.cells(7, 6).value = sub[4]
				xlsheet.cells(8, 3).value = sub[3].toString(10)
		} else {
			xlsheet.cells(2, 2).value = t['jst03']
				xlsheet.cells(7, 6).value = t['jst02']
				xlsheet.cells(7, 7).value = sub[4]
				xlsheet.cells(8, 3).value = (0 - eval(sub[3])).toString(10)
		}
		xlsheet.printout;
	xlsheet = null;
	xlBook.Close(savechanges = false);
	xlApp.Quit();
	xlApp = null;
	xlsheet = null;
	window.setInterval("Cleanup();", 1);
}

///Lid
///2009-05-20
///打印发票,押金号段明细(所有收费员)
function PrintInvDepNOALLDetails() {
	getpath();
	//var Template=path+"JF_InvDepNODetails.xls"
	var Template = "D:\\JF_InvDepNODetails.xls"
		xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(Template);
	xlsheet = xlBook.ActiveSheet

		var stDate = document.getElementById('stDate').value
		var endDate = document.getElementById('endDate').value
		var admDate = document.getElementById('lquser').value

		var Objtbl = document.getElementById('tUDHCJFrcptnum');
	Rows = Objtbl.rows.length;
	if (Rows < 2)
		return;
	var SelRowObj = document.getElementById('Tjobz' + 1);
	var job = SelRowObj.innerText;
	var useridStr = tkMakeServerCall("web.DHCIPBillInvDepCollect", "GetUserID", job)
		var useridNum = useridStr.split("^").length
		var currRow = 0
		for (i = 0; i < useridNum; i++) {
			currRow = currRow + 1;
			xlsheet.Range(xlsheet.Cells(currRow, 1), xlsheet.Cells(currRow, 14)).MergeCells = 1; //合并单元格
			xlsheet.cells(currRow, 1).value = ""; //报表标题;
			++currRow;
			//添加标题行
			xlsheet.Range(xlsheet.Cells(2, 1), xlsheet.Cells(2, 14)).Copy;
			xlsheet.Range(xlsheet.Cells(currRow, 1), xlsheet.Cells(currRow, 14)).PasteSpecial;

			var userid = useridStr.split("^")[i];
			var num = tkMakeServerCall("web.DHCIPBillInvDepCollect", "GetPrtNum", job, userid);
			for (j = 0; j < num; j++) {
				var rtn = tkMakeServerCall("web.DHCIPBillInvDepCollect", "GetPrtInfo", job, userid, j + 1)
					var strArray = rtn.split("^");
				++currRow;
				for (k = 0; k < strArray.length; k++) {
					xlsheet.cells(currRow, k + 1) = strArray[k]
						xlsheet.Cells(currRow, k + 1).Borders(9).LineStyle = 1
						xlsheet.Cells(currRow, k + 1).Borders(7).LineStyle = 1
						xlsheet.Cells(currRow, k + 1).Borders(10).LineStyle = 1
						xlsheet.Cells(currRow, k + 1).Borders(8).LineStyle = 1
				}
			}
			++currRow;
			xlsheet.Range(xlsheet.Cells(currRow, 1), xlsheet.Cells(currRow, 14)).MergeCells = 1; //合并单元格
			xlsheet.cells(currRow, 1) = "打印人:" + session['LOGON.USERNAME'] + "  打印日期:" + document.getElementById('prtDateTime').value;
			currRow = currRow + 4
		}
		xlApp.Visible = true
		xlsheet.PrintPreview();
	//xlsheet.printout
	xlBook.Close(savechanges = false);
	xlApp.Quit();
	xlApp = null;
	xlsheet = null
}
///Lid
///2009-08-12
///出院患者查询打印
function PrintDischFind() {
	Template = path + "JF_DischFind.xls"

		//Template="D:\\JF_DischFind.xls"
		xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(Template);
	xlsheet = xlBook.ActiveSheet
		xlsheet.cells(1, 1).value = HospitalDesc + "出院患者统计表"
		var StDate = document.getElementById('Stdate').value;
	//var StDate = StDate.split("/")
		//var StDateNew = StDate[2] + "-" + StDate[1] + "-" + StDate[0]
		var EndDate = document.getElementById('EndDate').value;
	//var EndDate = EndDate.split("/")
		//var EndDateNew = EndDate[2] + "-" + EndDate[1] + "-" + EndDate[0]
		xlsheet.cells(2, 2).value = StDate
		xlsheet.cells(2, 5).value = EndDate

		xlsheet.cells(2, 10).value = session['LOGON.USERNAME'];

	temp = yjData.join("!")
		vbdata = temp.split("!")
		var yjnumber = vbdata.length
		var i = 0
		for (i = 0; i <= vbdata.length - 1; i++) {
			str = vbdata[i].split(",")
				for (j = 0; j <= str.length - 1; j++) {
					xlsheet.cells(i + 4, j + 1) = str[j];
				}
		}
		//xlsheet.cells(i+4,1).value="制表人:"+session['LOGON.USERNAME'];
		//xlsheet.cells(i+4,5).value="审核人:";
		//xlsheet.cells(i+4,7).value="制表日期:";
		//AddGrid(objSheet,fRow,fCol,tRow,tCol,xlsTop,xlsLeft)
		AddGrid(xlsheet, 1, 1, vbdata.length, str.length + 1, 4, 1);

	xlApp.Visible = true
		xlsheet.PrintPreview();
	//xlsheet.printout
	xlBook.Close(savechanges = false);
	xlApp.Quit();
	xlApp = null;
	xlsheet = null
}
function prtInvDepDetails() {
	getpath();
	Template = path + "住院票据明细.xls"
		//Template="D:\\JF_InvDepDetails.xls"
		xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(Template);
	xlsheet = xlBook.ActiveSheet
		temp = strData.join("!")
		vbdata = temp.split("!")
		var yjnumber = vbdata.length
		var i = 0
		for (i = 0; i <= vbdata.length - 1; i++) {
			str = vbdata[i].split(",")
				for (j = 0; j <= str.length - 1; j++) {

					xlsheet.cells(i + 4, j + 1) = str[j]
						xlsheet.Cells(i + 4, j + 1).Borders(9).LineStyle = 1
						xlsheet.Cells(i + 4, j + 1).Borders(7).LineStyle = 1
						xlsheet.Cells(i + 4, j + 1).Borders(10).LineStyle = 1
						xlsheet.Cells(i + 4, j + 1).Borders(8).LineStyle = 1
				}
		}

		//xlsheet.cells(i+4,1).value="制表人:"+session['LOGON.USERCODE'];
		//xlsheet.cells(i+4,5).value="审核人:";
		//xlsheet.cells(i+4,7).value="制表日期:"+curdate;

		var stdate = document.getElementById("startDate").value
		var enddate = document.getElementById("enddate").value
		var year,
	mon,
	day,
	str
	//str = stdate.split("/")
		//day = str[0],
	//mon = str[1],
	//year = str[2]
	//	stdate = year + "-" + mon + "-" + day
		//str = enddate.split("/")
		//day = str[0],
	//mon = str[1],
	//year = str[2]
	//	enddate = year + "-" + mon + "-" + day
		xlsheet.cells(2, 2).value = stdate + "--" + enddate
		//xlApp.Visible=true
		//xlsheet.PrintPreview();
		xlBook.Close(savechanges = true);
	xlApp.Quit();
	xlApp = null;
	xlsheet = null
}
function getpath() {

	var getpath = document.getElementById('getpath');

	if (getpath) {
		var encmeth = getpath.value
	} else {
		var encmeth = ''
	};

	path = cspRunServerMethod(encmeth, '', '')

}
function printZYDB() //打印担保单
{
	var xlApp,
	xlsheet,
	xlBook;
	GetHospitalDesc();
	Template = path + "JF_ZYDB.xls";
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(Template);
	xlsheet = xlBook.ActiveSheet;
	xlsheet.cells(3, 2).value = HospitalDesc + "担保单";
	xlsheet.cells(4, 3) = patname1;
	xlsheet.cells(4, 5) = warrantor1;
	xlsheet.cells(4, 7) = money1;
	xlsheet.cells(6, 3) = startdate1;
	xlsheet.cells(6, 5) = enddate1;
	xlsheet.cells(6, 7) = username1;
	xlsheet.cells(7, 3) = remark1;
	xlsheet.printout;
	xlBook.Close(savechanges = false);
	xlApp = null;
	xlsheet = null;
}
function PrintDepAcount_click() {
	getpath()
	Template = path + "JF_Acount.xls"
		xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(Template);
	xlsheet = xlBook.ActiveSheet
		//xlsheet.cells(1,1)=t['03']
		//getcurdate()
		//var gettoday=document.getElementById('gettoday');
		//if (gettoday) {var encmeth=gettoday.value} else {var encmeth=''};
		//var curdate=cspRunServerMethod(encmeth)
		GetHospitalDesc()
		var SelRowObj = document.getElementById('Tjobz' + 1);
	job = SelRowObj.innerText;
	var getnum = document.getElementById('getprtnum');
	if (getnum) {
		var encmeth = getnum.value
	} else {
		var encmeth = ''
	};
	var num = cspRunServerMethod(encmeth, "YJACOUNT", job)
		var getprtinfo = document.getElementById('getprtinfo');
	if (getprtinfo) {
		var encmeth = getprtinfo.value
	} else {
		var encmeth = ''
	};
	var prtinfo = cspRunServerMethod(encmeth, "YJACOUNT", job, num)
		var columns = prtinfo.split("^")
		//xlsheet.cells(2,1)=t['04']+columns[0]+" "+columns[1]+"--"+columns[2]+" "+columns[3]

		xlsheet.cells(1, 1).value = HospitalDesc + "预交金帐"
		xlsheet.cells(2, 1) = t['04'] + columns[0] + " " + "00:00:00" + "--" + " " + columns[2] + " " + "23:59:59"
		if (num != 0) {
			for (i = 1; i < num - 1; i++) {
				var getprtinfo = document.getElementById('getprtinfo');
				if (getprtinfo) {
					var encmeth = getprtinfo.value
				} else {
					var encmeth = ''
				};
				var prtinfo = cspRunServerMethod(encmeth, "YJACOUNT", job, i)
					var columns = prtinfo.split("^")
					for (j = 0; j <= columns.length - 1; j++) {
						if (i > 1) {
							if (columns[2] != "") {
								columns[2] = eval(columns[2]).toFixed(2).toString(10)
							}
							if (columns[3] != "") {
								columns[3] = eval(columns[3]).toFixed(2).toString(10)
							}
							if (columns[5] != "") {
								columns[5] = eval(columns[5]).toFixed(2).toString(10)
							}
						}
						xlsheet.cells(2 + i, j + 1).value = columns[j]
							xlsheet.Cells(2 + i, j + 1).Borders(9).LineStyle = 1
							xlsheet.Cells(2 + i, j + 1).Borders(7).LineStyle = 1
							xlsheet.Cells(2 + i, j + 1).Borders(10).LineStyle = 1
							xlsheet.Cells(2 + i, j + 1).Borders(8).LineStyle = 1
					}
			}
		}

		xlsheet.cells(3 + i, 1).value = t['jst07'] + gusercode
		xlsheet.cells(3 + i, 3).value = t['jst09']
		xlsheet.cells(3 + i, 4).value = curdate
		xlsheet.cells(3 + i, 4).HorizontalAlignment = -4131
		xlsheet.cells(5 + i, 1).value = t['jst10']
		xlsheet.cells(5 + i, 3).value = t['jst11']
		xlApp.Visible = true
		xlsheet.PrintPreview();
	xlBook.Close(savechanges = false);
	xlApp.Quit();
	xlApp = null;
	xlsheet = null
}
//取医院名称，打印名称前增加医院名称
function GetHospitalDesc() {
	HospitalDesc = tkMakeServerCall("web.UDHCJFCOMMON", "gethospital");
}
function PrintCatFeeAcount_click() {
	getpath()
	GetHospitalDesc()
	Template = path + "JF_FLAcount.xls"
		xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(Template);
	xlsheet = xlBook.ActiveSheet
		//  xlsheet.cells(1,1)=""
		var SelRowObj = document.getElementById('Tjobz' + 1);
	job = SelRowObj.innerText;
	//var gettoday=document.getElementById('gettoday');
	//if (gettoday) {var encmeth=gettoday.value} else {var encmeth=''};
	//var curdate=cspRunServerMethod(encmeth)
	var getnum = document.getElementById('getprtnum');
	if (getnum) {
		var encmeth = getnum.value
	} else {
		var encmeth = ''
	};
	var num = cspRunServerMethod(encmeth, "FLFEEACOUNT", job)
		var getprtinfo = document.getElementById('getprtinfo');
	if (getprtinfo) {
		var encmeth = getprtinfo.value
	} else {
		var encmeth = ''
	};
	var prtinfo = cspRunServerMethod(encmeth, "FLFEEACOUNT", job, num)
		var columns = prtinfo.split("^")
		xlsheet.cells(1, 1).value = HospitalDesc + "应收在院住院费用帐"
		xlsheet.cells(2, 2) = t['04'] + columns[0] + " " + columns[1] + "--" + columns[2] + " " + columns[3]
		if (num != 0) {
			for (i = 1; i < num; i++) {
				var getprtinfo = document.getElementById('getprtinfo');
				if (getprtinfo) {
					var encmeth = getprtinfo.value
				} else {
					var encmeth = ''
				};
				var prtinfo = cspRunServerMethod(encmeth, "FLFEEACOUNT", job, i)
					var columns = prtinfo.split("^")
					for (j = 1; j < columns.length - 1; j++) {
						if (i > 1) {
							if (columns[2] != "") {
								columns[2] = eval(columns[2]).toFixed(2).toString(10)
							}
							if (columns[3] != "") {
								columns[3] = eval(columns[3]).toFixed(2).toString(10)
							}
							if (columns[4] != "") {
								columns[4] = eval(columns[4]).toFixed(2).toString(10)
							}
							if (columns[5] != "") {
								columns[5] = eval(columns[5]).toFixed(2).toString(10)
							}
						}
						xlsheet.cells(2 + i, j + 1) = columns[j]
							xlsheet.Cells(2 + i, j + 1).Borders(9).LineStyle = 1
							xlsheet.Cells(2 + i, j + 1).Borders(7).LineStyle = 1
							xlsheet.Cells(2 + i, j + 1).Borders(10).LineStyle = 1
							xlsheet.Cells(2 + i, j + 1).Borders(8).LineStyle = 1
					}
			}
		}
		xlsheet.cells(3 + i, 2).value = t['jst07'] + gusercode
		xlsheet.cells(3 + i, 4).value = t['jst09']
		xlsheet.cells(3 + i, 5).value = curdate
		xlsheet.cells(3 + i, 5).HorizontalAlignment = -4131
		xlsheet.cells(5 + i, 2).value = t['jst10']
		xlsheet.cells(5 + i, 4).value = t['jst11']
		xlApp.Visible = true
		xlsheet.PrintPreview();
	xlBook.Close(savechanges = false);
	xlApp.Quit();
	xlApp = null;
	xlsheet = null
}
function PrintFeeAcount_click() {
	getpath()
	Template = path + "JF_Acount.xls"
		xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(Template);
	xlsheet = xlBook.ActiveSheet
		xlsheet.cells(1, 1) = "住院病人应收帐"
		var SelRowObj = document.getElementById('Tjobz' + 1);
	job = SelRowObj.innerText;
	//var gettoday=document.getElementById('gettoday');
	//if (gettoday) {var encmeth=gettoday.value} else {var encmeth=''};
	//var curdate=cspRunServerMethod(encmeth)
	var getnum = document.getElementById('getprtnum');
	if (getnum) {
		var encmeth = getnum.value
	} else {
		var encmeth = ''
	};
	var num = cspRunServerMethod(encmeth, "FEEACOUNT", job)
		var getprtinfo = document.getElementById('getprtinfo');
	if (getprtinfo) {
		var encmeth = getprtinfo.value
	} else {
		var encmeth = ''
	};
	var prtinfo = cspRunServerMethod(encmeth, "FEEACOUNT", job, num)

		var columns = prtinfo.split("^")
		GetHospitalDesc()
		xlsheet.cells(1, 1).value = HospitalDesc + "应收在院帐"
		xlsheet.cells(2, 1) = t['04'] + columns[0] + " " + columns[1] + "--" + columns[2] + " " + columns[3]
		if (num != 0) {
			for (i = 1; i < num; i++) {
				var getprtinfo = document.getElementById('getprtinfo');
				if (getprtinfo) {
					var encmeth = getprtinfo.value
				} else {
					var encmeth = ''
				};
				var prtinfo = cspRunServerMethod(encmeth, "FEEACOUNT", job, i)
					var columns = prtinfo.split("^")
					for (j = 0; j <= columns.length - 1; j++) {
						if (i > 1) {
							if (columns[2] != "") {
								columns[2] = eval(columns[2]).toFixed(2).toString(10)
							}
							if (columns[3] != "") {
								columns[3] = eval(columns[3]).toFixed(2).toString(10)
							}
							if (columns[5] != "") {
								columns[5] = eval(columns[5]).toFixed(2).toString(10)
							}
						}
						xlsheet.cells(2 + i, j + 1) = columns[j]
							xlsheet.Cells(2 + i, j + 1).Borders(9).LineStyle = 1
							xlsheet.Cells(2 + i, j + 1).Borders(7).LineStyle = 1
							xlsheet.Cells(2 + i, j + 1).Borders(10).LineStyle = 1
							xlsheet.Cells(2 + i, j + 1).Borders(8).LineStyle = 1
					}
			}
		}
		xlsheet.cells(3 + i, 1).value = t['jst07'] + gusercode
		xlsheet.cells(3 + i, 3).value = t['jst09']
		xlsheet.cells(3 + i, 4).value = curdate
		xlsheet.cells(3 + i, 4).HorizontalAlignment = -4131
		xlsheet.cells(5 + i, 1).value = t['jst10']
		xlsheet.cells(5 + i, 3).value = t['jst11']
		xlApp.Visible = true
		xlsheet.PrintPreview();
	xlBook.Close(savechanges = false);
	xlApp.Quit();
	xlApp = null;
	xlsheet = null
}
function PrintBillDetail() {
	var xlApp,
	obook,
	osheet,
	xlsheet,
	xlBook,
	temp,
	str,
	vbdata,
	i,
	j
	var Template
	Template = path + "JF_PatFeeDetail.xls"
		//Template="D:\\JF_PatFeeDetail.xls"
		xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(Template);
	xlsheet = xlBook.ActiveSheet
		str = tmpstr.split("#");
	patstr = str[0].split("^");
	admstr = str[1].split("^");
	var CurDate = document.getElementById('CurDate').value
		var currRow = 1
		GetHospitalDesc()
		var VisitStatus
		VisitStatus = admstr[7]
		xlsheet.cells(currRow, 1).value = HospitalDesc + "费用结算清单";
	xlsheet.cells(++currRow, 1).value = "登记号:" + patstr[0] + "  住院号:" + patstr[2] + "  姓 名: " + patstr[1] + "  性 别: " + patstr[4] + "  出院科室: " + admstr[3]//"科  室:"+str2[3]+
		if (VisitStatus == "D") {
			xlsheet.cells(++currRow, 1).value = "入院日期: " + admstr[0] + "  出院日期: " + admstr[1] + "  住院天数: " + admstr[6] + "   费用合计: " + admstr[8];
		} else {
			xlsheet.cells(++currRow, 1).value = "入院日期: " + admstr[0] + "  结束日期: " + admstr[1] + "  住院天数: " + admstr[6] + "   费用合计: " + admstr[8];
		}

		var objtbl = document.getElementById('tUDHCJFBillDetail');
	++currRow;
	/*
	for (j=1;j<objtbl.rows(0).cells.length-2;j++)   {
	xlsheet.cells(currRow,j)=objtbl.rows(0).cells(j).innerText
	}  */
	CellLine(xlsheet, currRow, currRow, 1, 8, 3, 1)
	CellLine(xlsheet, currRow, currRow, 1, 8, 4, 1)
	GetNum();
	var prtRow = currRow
		for (i = 1; i <= num; i++) {
			var str = ListPrt(i)
				//alert(str);
				str = str.split("^")
				var qty = str[4];
			var sum = str[5];

			for (j = 1; j < 8; j++) {

				if (str[j - 1] == "小计:") {
					CellLine(xlsheet, i + prtRow, i + prtRow, 6, 8, 3, 2)
					CellLine(xlsheet, i + prtRow, i + prtRow, 1, 8, 4, 1)
					xlsheet.rows(i + prtRow).Font.Bold = true;
				}

				if (str[j - 1] == "合计:") {
					CellLine(xlsheet, i + 5, i + 5, 1, 8, 3, 1)
					xlsheet.rows(i + prtRow).Font.Bold = true;
				}

				xlsheet.cells(i + prtRow, j) = str[j - 1]
			}

			++currRow
		}
		++currRow;
	xlsheet.cells(currRow, 1).value = "            打印人: " + session['LOGON.USERCODE'] + "                            打印时间: " + CurDate
		xlsheet.cells(currRow + 1, 1).value = t['comment']; //xlsheet.printout(1,xlsheet.HPageBreaks.count+1,1,false,"brfyqd");
	xlApp.Visible = true
		xlsheet.PrintPreview();
	xlBook.Close(savechanges = false);
	xlApp.Quit();
	xlApp = null;
	xlsheet = null
}
function printQFPATIENT() {

	var xlApp,
	xlsheet,
	xlBook,
	i,
	j,
	temp,
	vbdata
	var rows,
	k
	var strr
	Template = path + "JF_QFPAT.xls"
		xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(Template);
	xlsheet = xlBook.ActiveSheet
		xlsheet.cells(1, 1) = HospitalDesc + "住院欠费病人表"
		//var objtbl=document.getElementById('tUDHCJFQFPATIENT');
		for (i = 1; i <= num; i++) {

			var str = ListPrt(i)
				str = str.split("^")

				for (j = 1; j <= str.length; j++) {
					xlsheet.cells(i + 4, j) = str[j - 1]
				}
				AddGrid(xlsheet, 0, 2, 1, str.length + 1, i + 3, 1)
		}
		//var currRow=5 + Number(num);
		xlsheet.cells(3, 10) = locdesc;
	xlsheet.cells(3, 5) = stdate;
	xlsheet.cells(3, 7) = enddate;
	//xlsheet.cells(currRow, 2) = "制表人："+session['LOGON.USERNAME'];
	//xlsheet.PrintPreview();
	xlsheet.printout
	xlBook.Close(savechanges = false);
	xlApp.Quit();
	xlApp = null;
	xlsheet = null;
}
function AddGrid(objSheet, fRow, fCol, tRow, tCol, xlsTop, xlsLeft) {
	objSheet.Range(objSheet.Cells(xlsTop, xlsLeft), objSheet.Cells(xlsTop + tRow - fRow, xlsLeft + tCol - fCol)).Borders(1).LineStyle = 1;
	objSheet.Range(objSheet.Cells(xlsTop, xlsLeft), objSheet.Cells(xlsTop + tRow - fRow, xlsLeft + tCol - fCol)).Borders(2).LineStyle = 1;
	objSheet.Range(objSheet.Cells(xlsTop, xlsLeft), objSheet.Cells(xlsTop + tRow - fRow, xlsLeft + tCol - fCol)).Borders(3).LineStyle = 1;
	objSheet.Range(objSheet.Cells(xlsTop, xlsLeft), objSheet.Cells(xlsTop + tRow - fRow, xlsLeft + tCol - fCol)).Borders(4).LineStyle = 1;
}
function SelectCKDPrint_Click() {
	//循环调用打印
	var xlApp,
	obook,
	osheet,
	xlsheet,
	xlBook
	var Template
	GetHospitalDesc()
	Template = path + "DHCIPBillCKD.xls"
		//Template="D:\\DHCIPBillCKD.xls"
		var Objtbl = document.getElementById('tUDHCJFCKD');
	var Rows = Objtbl.rows.length;
	for (i = 1; i <= Rows - 1; i++) {
		var SelRowObj = document.getElementById('SelectPatz' + i);
		if (SelRowObj.checked == true) {
			xlApp = new ActiveXObject("Excel.Application");
			xlBook = xlApp.Workbooks.Add(Template);
			xlsheet = xlBook.ActiveSheet
				xlsheet.cells(2, 1).value = HospitalDesc + "住院催款单"
				var PatWard = document.getElementById('Tlocz' + i).innerText
				var PatBed = document.getElementById('Tbedz' + i).innerText
				var PatName = document.getElementById('Tnamez' + i).innerText
				var PatMedicare = document.getElementById('TPatMedicarez' + i).innerText
				var PatDeposit = document.getElementById('Tdepositz' + i).innerText
				var PatAmount = document.getElementById('Tamountz' + i).innerText
				var PrtInfo1 = PatWard + " 病房" + PatBed + "    " + PatName + "  同志（住院号  " + PatMedicare + "）:"
				var PrtInfo2 = "您本次住院已交住院预交金    " + PatDeposit + "元," + "目前实际发生费用"
				var PrtInfo3 = "为:  " + PatAmount + "  ,现需补交住院费，具体补交金额请您咨询主管医生."
				xlsheet.cells(3, 2).value = PrtInfo1
				xlsheet.cells(4, 2).value = PrtInfo2
				xlsheet.cells(5, 2).value = PrtInfo3
				var myDate = new Date();
			var CurDate = myDate.toLocaleDateString();

			xlsheet.cells(9, 2).value = CurDate
				//add by wangjian 2015-01-26
				var myCondition = '{PatWard:"' + PatWard + '",PatBed:"' + PatBed + '",PatMedicare:"' + PatMedicare + '"}'
				var myContent = '{PrtInfo1:"' + PrtInfo1 + '",PrtInfo2:"' + PrtInfo2 + '",PrtInfo3:"' + PrtInfo3 + '"}'
				var PAPMIID = tkMakeServerCall("web.UDHCJFIPReg", "GetPapmiId", "", PatMedicare)
				var mySecretCodeStr = tkMakeServerCall("web.UDHCJFBaseCommon", "GetPatEncryptLevel", PAPMIID, "")
				var mySecretCode = mySecretCodeStr.split("^")[2];
			websys_EventLog("UDHCJFCKD.PrintCKD", myCondition, myContent, mySecretCode);
			//end
			xlsheet.printout

			xlBook.Close(savechanges = false);
			xlApp.Quit();
			xlApp = null;
			xlsheet = null

		}
	}
}
function PrintCKD_Click() {
	var xlApp,
	obook,
	osheet,
	xlsheet,
	xlBook
	var Template
	GetHospitalDesc()
	Template = path + "DHCIPBillCKD.xls"
		//Template="D:\\DHCIPBillCKD.xls"
		var Objtbl = document.getElementById('tUDHCJFCKD');
	var Rows = Objtbl.rows.length;
	for (i = 1; i <= Rows - 1; i++) {
		var SelRowObj = document.getElementById('SelectPatz' + i);
		xlApp = new ActiveXObject("Excel.Application");
		xlBook = xlApp.Workbooks.Add(Template);
		xlsheet = xlBook.ActiveSheet

			xlsheet.cells(2, 1).value = HospitalDesc + "住院催款单"
			var PatWard = document.getElementById('Tlocz' + i).innerText
			var PatBed = document.getElementById('Tbedz' + i).innerText
			var PatName = document.getElementById('Tnamez' + i).innerText
			var PatMedicare = document.getElementById('TPatMedicarez' + i).innerText
			var PatDeposit = document.getElementById('Tdepositz' + i).innerText
			var PatAmount = document.getElementById('Tamountz' + i).innerText
			var PrtInfo1 = PatWard + " 病房" + PatBed + "    " + PatName + "  同志（住院号  " + PatMedicare + "）:"
			var PrtInfo2 = "您本次住院已交住院预交金    " + PatDeposit + "元," + "目前实际发生费用"
			var PrtInfo3 = "为:  " + PatAmount + "  ,现需补交住院费，具体补交金额请您咨询主管医生."
			xlsheet.cells(3, 2).value = PrtInfo1
			xlsheet.cells(4, 2).value = PrtInfo2
			xlsheet.cells(5, 2).value = PrtInfo3
			var myDate = new Date();
		var CurDate = myDate.toLocaleDateString();
		xlsheet.cells(9, 2).value = CurDate + "          "

			//add by wangjian 2015-01-26
			var myCondition = '{PatWard:"' + PatWard + '",PatBed:"' + PatBed + '",PatMedicare:"' + PatMedicare + '"}'
			var myContent = '{PrtInfo1:"' + PrtInfo1 + '",PrtInfo2:"' + PrtInfo2 + '",PrtInfo3:"' + PrtInfo3 + '"}'
			var PAPMIID = tkMakeServerCall("web.UDHCJFIPReg", "GetPapmiId", "", PatMedicare)
			var mySecretCodeStr = tkMakeServerCall("web.UDHCJFBaseCommon", "GetPatEncryptLevel", PAPMIID, "")
			var mySecretCode = mySecretCodeStr.split("^")[2];
		websys_EventLog("UDHCJFCKD.PrintCKD", myCondition, myContent, mySecretCode);
		//end

		xlsheet.printout

		xlBook.Close(savechanges = false);
		xlApp.Quit();
		xlApp = null;
		xlsheet = null

	}
}
function Prt_FYQingDan() {
	var billDr = $V("BillNo");
	if (billDr == "") {
		alert("请选择打印台账的账单.")
		return
	}
	//var getFYQingDanObj = document.getElementById('getFYQingDan');
	//if (getFYQingDanObj) {var encmeth = getFYQingDanObj.value}else {var encmeth=''};
	//var returnvalue = cspRunServerMethod(encmeth,"PrintFootList",billDr)	//UDHCJFDayPrint.js
	var returnvalue = tkMakeServerCall("web.UDHCJFPRINTINV", "PrintReceipt", "PrintFootList", billDr)
}

///wanghuicai
///2009-6-2
///打印收费结算清单 UDHCJFPAY.JS,UDHCJFPAY.CLS
function PrintFootList(tarICDescStr, tarICFeeStr, details) {
	path = tkMakeServerCall("web.UDHCJFCOMMON", "getpath", "", "")

		var Template = path + "DHCJF_FootList.xls";
	var xlApp,
	xlsheet,
	xlBook;
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(Template);
	xlsheet = xlBook.ActiveSheet;

	//打印表内有规律的数据
	var desc = tarICDescStr.split("^");
	var fee = tarICFeeStr.split("^");
	var descLen = desc.length;
	k = 0;
	for (i = 0; i < (descLen / 7); i++) {
		for (j = 1; j <= 7; j++) {
			xlsheet.cells(2 * i + 6, j + 1) = desc[k]; //打印出大类描述
			xlsheet.cells(2 * i + 7, j + 1) = fee[k]; //打印出对应的费用
			k++;
			if (k == descLen - 2) {
				break;
			}
		}
	}
	xlsheet.cells(10, 8) = desc[descLen - 2]; //打印小计
	xlsheet.cells(11, 8) = fee[descLen - 2]; //小计的费用
	xlsheet.cells(12, 2) = fee[descLen - 1]; //小计大写
	var dtl = details.split("^")
		xlsheet.cells(2, 2) = dtl[0]//病历号
		xlsheet.cells(4, 2) = dtl[1]//住院日期
		xlsheet.cells(4, 7) = dtl[2]//收据号
		xlsheet.cells(5, 2) = dtl[3]//病历号
		xlsheet.cells(5, 4) = dtl[4]//登记号
		xlsheet.cells(5, 6) = dtl[5]//支票号
		xlsheet.cells(5, 8) = dtl[6]//科别
		xlsheet.cells(14, 2) = dtl[7]//预交金
		dtl[8] = dtl[8].replace(/\#/g, " ");
	dtl[8] = dtl[8].replace(/(\&\&)/g, " ,");
	xlsheet.cells(13, 2) = dtl[8]//备注
		xlsheet.cells(15, 2) = dtl[9]//收款日期
		/// add by zhl 090721  S
		xlsheet.cells(14, 6) = dtl[10]//补交合计
		xlsheet.cells(14, 8) = dtl[11]//退费合计

		///E
		xlsheet.cells(15, 6) = dtl[12]; //收款人
		xlsheet.cells(15, 8) = session['LOGON.USERCODE']; //经手人
	xlsheet.cells(16, 2) = dtl[13]

		//xlApp.Visible=true
		xlsheet.printout;
	//xlsheet.printout
	xlBook.Close(savechanges = false);
	xlApp.Quit();
	xlApp = null;
	xlsheet = null
}