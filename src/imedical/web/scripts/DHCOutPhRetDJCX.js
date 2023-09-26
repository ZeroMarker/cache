//DHCOutPhRetDJCX
var bottomFrame;
var topFrame;
var tblobj = document.getElementById("tDHCOutPhRetDJCX");
var evtName;
var doneInit = 0;
var focusat = null;
var SelectedRow = 0;
var pmiobj, pnameobj;
var stdateobj, enddateobj;
var phlobj, phwobj, locdescobj, phwdescobj, pydrobj, fydrobj, pynameobj, fynameobj;
var ctlocobj;
var BResetobj, BPrintobj;
var printobj, dispobj, reprintobj;
var returnphobj, returnphitmobj;
if (parent.name == 'TRAK_main') {
    topFrame = parent.frames['DHCOutPatienRetDJCX'];
    bottomFrame = parent.frames['DHCOutPatienRetDJCXSub'];
} else {
    topFrame = parent.frames['TRAK_main'].frames['DHCOutPatienRetDJCX'];
    bottomFrame = parent.frames['TRAK_main'].frames['DHCOutPatienRetDJCXSub'];
}




var subtblobj = bottomFrame.document.getElementById('tDHCOutPhRetDJCXSub');


function BodyLoadHandler() {
    BResetobj = document.getElementById("BReset");
    if (BResetobj) BResetobj.onclick = Reset_click;
    BRetrieveobj = document.getElementById("BRetrieve");
    if (BRetrieveobj)
        if (BRetrieveobj) {
            BRetrieveobj.onclick = Retrieve_click;
            if (tbl.rows.length > 1) { RowClick(); } else {
                var ret = ""
                var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOutPhRetDJCXSub&ret=" + ret;
                bottomFrame.location.href = lnk;
            }
        }

    BPrintobj = document.getElementById("BPrint");
    if (BPrintobj) BPrintobj.onclick = Print_click;
    ctlocobj = document.getElementById("ctloc");
    useridobj = document.getElementById("userid");

    BPrintobj = document.getElementById("BCancleReturn");
    if (BPrintobj) BPrintobj.onclick = BCancleReturnClick;

}

function BCancleReturnClick() {
    if (!(SelectedRow > 0)) {
        alert("����ѡ����ҩ��")
        return;
    }
    var retrow = document.getElementById("TRetRowidz" + SelectedRow).value

    var ret = 0
    var getCancleReturn = document.getElementById('mCancleReturn');
    if (getCancleReturn) { var encmeth = getCancleReturn.value } else { var encmeth = '' };
    ret = cspRunServerMethod(encmeth, retrow)
    if (ret == "-1") {
        alert("��ʾ���ǵ������ҩ��¼,���ܳ�����")
        return;
    }
    if (ret == "-2") {
        alert("��ʾ����ҩ���ݶ�Ӧ�շѼ�¼������,��˶ԣ�")
        return;
    }
    if (ret == "-3") {
        alert("��ʾ��������¼���˷�,���ܳ�����")
        return;
    }
    if (ret == "-4") {
        alert("��ʾ��������¼�ѳ�����ҩ,��˶ԣ�")
        return;
    }
    if (ret != 0) {
        alert("��ʾ������ʧ��,����ϵ�����Ա���д���")
        return;
    } else {
        alert("�����ɹ�")
        Retrieve_click();
    }

}

function SelectRowHandler() {

    var eSrc = window.event.srcElement;
    if (eSrc.tagName == "IMG") eSrc = window.event.srcElement.parentElement;
    var eSrcAry = eSrc.id.split("z");
    var rowObj = getRow(eSrc);
    var selectrow = rowObj.rowIndex;
    if (!selectrow) return;
    SelectedRow = selectrow;
    var tmpobjrow = tblobj.rows[selectrow];
    if (selectrow == 1) {
        tblobj.rows[1].className = "clsRowSelected"
    } else {
        tblobj.rows[1].className = "RowEven"
    }
    var retrow = document.getElementById("TRetRowidz" + selectrow).value
    var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOutPhRetDJCXSub&ret=" + retrow;
    bottomFrame.location.href = lnk;
}

function RowClick() {
    var objfirstrow = tblobj.rows[1];
    objfirstrow.className = "clsRowSelected"
    var ret = document.getElementById("TRetRowidz" + 1).value
    SelectedRow = 1
    var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOutPhRetDJCXSub&ret=" + ret;
    bottomFrame.location.href = lnk;
}

function Reset_click() {
    location.href = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOutPhRetDJCX";
    var ret = ""
    var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOutPhRetDJCXSub&ret=" + ret;
    bottomFrame.location.href = lnk;
}

function Print_click() {
	var retrow = document.getElementById("TRetRowidz" + SelectedRow).value;
	PrintReturn(retrow,"��")
}

function Retrieve_click() {
    stdateobj = document.getElementById("CDateSt")
    enddateobj = document.getElementById("CDateEnd")
    ctlocobj = document.getElementById("ctloc")
    var ctloc = ctlocobj.value;
    var stdate = stdateobj.value
    var enddate = enddateobj.value
    var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOutPhRetDJCX&CDateSt=" + stdate + "&CDateEnd=" + enddate + "&ctloc=" + ctloc;
    topFrame.location.href = lnk;
}
document.body.onload = BodyLoadHandler;