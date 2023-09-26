///סԺ��ҩlodop��ӡ����JS
///Creator:dinghongying
///CreateDate:2018-08-28
///dhcpha.inpha.lodopprint.js

///סԺ��ҩ���ܵ���ӡ
function CreatDispTotalPrint(LODOP,colarray,mainData){
	if(mainData==""){
		return;
	}
	var mainArr=mainData.split("^");	
	var HospitalDesc=tkMakeServerCall("web.DHCSTKUTIL","GetHospName",session['LOGON.HOSPID'])
	var Ward=mainArr[0];
	var DispNo=mainArr[1];
	var ColDate=mainArr[2];
	var ColTime=mainArr[6];
	var PhaType=mainArr[5];
	var User=mainArr[3];
	var PhaLoc=mainArr[4];
	var Priority=mainArr[7];
	var PrnDateTime=mainArr[8];
	var ColDate=ColDate+" "+ColTime ;
    LODOP.PRINT_INIT("��ҩ���ܱ�");
    LODOP.SET_PRINT_PAGESIZE(1, 0, 0, "A4");
    LODOP.ADD_PRINT_TEXT(15, 25, 600, 70, HospitalDesc+PhaLoc+ "��ҩ���ܱ�");
    LODOP.SET_PRINT_STYLEA(0, "FontName", "����");
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 14);
    LODOP.SET_PRINT_STYLEA(0, "Alignment", 2);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "Horient", 2);
    LODOP.ADD_PRINT_TEXT(55, 80, "100%", 28, "������ң�" + Ward);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 12);
    LODOP.ADD_PRINT_TEXT(55, 420, "100%", 28, "��ҩ���" + PhaType);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 12);
    LODOP.ADD_PRINT_TEXT(85, 80, "100%", 28, "���ţ�" + DispNo);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 12);
    LODOP.ADD_PRINT_TEXT(85, 420, "100%", 28, "��ҩʱ�䣺" + ColDate);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 12);
    /*LODOP.ADD_PRINT_TEXT(115, 20, "100%", 28, "�Ƶ��ˣ�" + User);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 12);
    LODOP.ADD_PRINT_TEXT(115, 400, "100%", 28, "��ӡʱ�䣺" + PrnDateTime);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 12);
    LODOP.ADD_PRINT_HTM(115,700,"100%",28,"<span tdata='pageNO'>��##ҳ</span> <span tdata='pageCount'>��##ҳ</span>");
    LODOP.SET_PRINT_STYLEA(0,"ItemType",1);*/
    var html = "<style>table,td,th {border: 1px solid black;border-style: solid;border-collapse: collapse;font-size:16px;} table{table-layout:fixed;display:table;} tfoot,th{ border:none;font-size:16px;}</style><table>";
    html +="<thead>";
    html += "<tr><td >" + "ҩƷ����" + "</td>"; 
    html += "<td >" + "���" + "</td>"; 
    html += "<td >" + "��ҩ����" + "</td>"; 
    html += "<td >" + "��λ" + "</td>"; 
    html += "<td >" + "�ܼ�" + "</td>";
    html += "<td >" + "ҽ����" + "</td>"; 
    html += "<td >" + "�����" + "</td>"; 
    html += "<td >" + "��λ����" + "</td></tr>"; 
    html +="</thead>";
    html +="<tbody>";
    for (var i = 0; i < colarray.rows.length; i++) {
        var printData = colarray.rows[i];
        html += "<tr>";
		html += "<td>" + printData.InciDesc + "</td>";
		html += "<td>" + printData.Spec + "</td>";
		html += "<td>" + printData.FacQty + "</td>";
		html += "<td>" + printData.StkBin + "</td>";
		html += "<td>" + printData.Amt + "</td>";
		html += "<td>" + printData.Qty + "</td>";
		html += "<td>" + printData.ResQty + "</td>";
		html += "<td>" + printData.bedInciTotal + "</td>";
        html += "</tr>";
    }
    html += "</tbody><tfoot>";
    html += "<tr>";
	html += "<th colspan='3'>" + "��ӡʱ�䣺" + PrnDateTime + "</th>";
	html += "<th colspan='1'>" + " "+ "</th>";
	html += "<th colspan='2'>" + "�Ƶ��ˣ�" + User + "</th>";
	html += "<th colspan='2'>" + "<span tdata='pageNO'>��##ҳ</span> <span tdata='pageCount'>��##ҳ</span>" + "</th>";
    html += "</tr>";
    html += "</tfoot></table>";
    html +=html;
    LODOP.ADD_PRINT_TABLE(125, 0, "100%", "100%", html);
}

///סԺ��ҩ��ϸ��
function CreatDispDetailPrint(LODOP,colarray,mainData){
	if(mainData==""){
		return;
	}
	var mainArr=mainData.split("^");	
	var HospitalDesc=tkMakeServerCall("web.DHCSTKUTIL","GetHospName",session['LOGON.HOSPID'])
	var Ward=mainArr[0];
	var DispNo=mainArr[1];
	var ColDate=mainArr[2];
	var ColTime=mainArr[6];
	var PhaType=mainArr[5];
	var User=mainArr[3];
	var PhaLoc=mainArr[4];
	var Priority=mainArr[7];
	var PrnDateTime=mainArr[8];
	var ColDate=ColDate+" "+ColTime ;
    LODOP.PRINT_INIT("��ҩ��ϸ��");
    LODOP.SET_PRINT_PAGESIZE(1, 0, 0, "A4");
    LODOP.ADD_PRINT_TEXT(15, 25, 600, 70, HospitalDesc+PhaLoc+ "��ҩ��ϸ��");
    LODOP.SET_PRINT_STYLEA(0, "FontName", "����");
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 14);
    LODOP.SET_PRINT_STYLEA(0, "Alignment", 2);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "Horient", 2);
    LODOP.ADD_PRINT_TEXT(55, 60, "100%", 28, "������ң�" + Ward);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 12);
    LODOP.ADD_PRINT_TEXT(55, 420, "100%", 28, "��ҩ���" + PhaType);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 12);
    LODOP.ADD_PRINT_TEXT(85, 60, "100%", 28, "���ţ�" + DispNo);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 12);
    LODOP.ADD_PRINT_TEXT(85, 420, "100%", 28, "��ҩʱ�䣺" + ColDate);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 12);
    /*LODOP.ADD_PRINT_TEXT(115, 20, "100%", 28, "�Ƶ��ˣ�" + User);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 12);
    LODOP.ADD_PRINT_TEXT(115, 400, "100%", 28, "��ӡʱ�䣺" + PrnDateTime);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 12);
    LODOP.ADD_PRINT_HTM(115,700,"100%",28,"<span tdata='pageNO'>��##ҳ</span> <span tdata='pageCount'>��##ҳ</span>");
    LODOP.SET_PRINT_STYLEA(0,"ItemType",1);*/
    var html = "<style>table,td,th {border: 1px solid black;border-style: solid;border-collapse: collapse;font-size:16px;} table{table-layout:fixed;display:table;} tfoot,th{ border:none;font-size:16px;}</style><table>";
    html +="<thead>";
    html += "<tr><td>" + "����" + "</td>"; 
    html += "<td>" + "����" + "</td>"; 
    html += "<td>" + "ҩƷ����" + "</td>"; 
    html += "<td>" + "����" + "</td>"; 
    html += "<td>" + "��λ" + "</td>";
    html += "<td>" + "Ƶ��" + "</td>"; 
    html += "<td>" + "�÷�" + "</td>"; 
    html += "<td>" + "ʱ��" + "</td>";
    html += "<td>" + "���" + "</td>"; 
    html += "<td>" + "����" + "</td></tr>"; 
    html +="</thead>";
    html += "<tbody>";
    for (var i = 0; i < colarray.rows.length; i++) {
        var printData = colarray.rows[i];
        html += "<tr>";
		html += "<td>" + printData.BedNo + "</td>";
		html += "<td>" + printData.PatName + "</td>";
		html += "<td>" + printData.ArcimDesc + "</td>";
		html += "<td>" + printData.DoseQty + "</td>";
		html += "<td>" + printData.DoseUomDesc + "</td>";
		html += "<td>" + printData.Freq + "</td>";
		html += "<td>" + printData.Instruction + "</td>";
		html += "<td>" + printData.TimeDosingStr + "</td>";
		html += "<td>" + printData.Spec + "</td>";
		html += "<td>" + printData.Qty + "</td>";
        html += "</tr>";
    }
    html += "</tbody><tfoot>";
    html += "<tr>";
	html += "<th colspan='3'>" + "��ӡʱ�䣺" + PrnDateTime + "</th>";
	html += "<th colspan='1'>" + " "+ "</th>";
	html += "<th colspan='3'>" + "�Ƶ��ˣ�" + User + "</th>";
	html += "<th colspan='3'>" + "<span tdata='pageNO'>��##ҳ</span> <span tdata='pageCount'>��##ҳ</span>" + "</th>";
    html += "</tr>";
    html += "</tfoot></table>";
    html +=html;
    LODOP.ADD_PRINT_TABLE(125, 0, "100%", "100%", html);
    LODOP.PREVIEW();
}

///סԺ��ҩ������ܴ�ӡ
function CreatDispTotalResPrint(LODOP,colarray,mainData){
	if(mainData==""){
		return;
	}
	var mainArr=mainData.split("^");	
	var HospitalDesc=tkMakeServerCall("web.DHCSTKUTIL","GetHospName",session['LOGON.HOSPID'])
	var Ward=mainArr[0];
	var DispNo=mainArr[1];
	var ColDate=mainArr[2];
	var ColTime=mainArr[6];
	var PhaType=mainArr[5];
	var User=mainArr[3];
	var PhaLoc=mainArr[4];
	var Priority=mainArr[7];
	var PrnDateTime=mainArr[8];
	var ColDate=ColDate+" "+ColTime ;
    LODOP.PRINT_INIT("��ҩ���ܱ�");
    LODOP.SET_PRINT_PAGESIZE(1, 0, 0, "A4");
    LODOP.ADD_PRINT_TEXT(15, 25, 600, 70, HospitalDesc+PhaLoc+ "��ҩ������ܱ�");
    LODOP.SET_PRINT_STYLEA(0, "FontName", "����");
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 14);
    LODOP.SET_PRINT_STYLEA(0, "Alignment", 2);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "Horient", 2);
    LODOP.ADD_PRINT_TEXT(55, 80, "100%", 28, "������ң�" + Ward);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 12);
    LODOP.ADD_PRINT_TEXT(55, 420, "100%", 28, "��ҩ���" + PhaType);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 12);
    LODOP.ADD_PRINT_TEXT(85, 80, "100%", 28, "���ţ�" + DispNo);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 12);
    LODOP.ADD_PRINT_TEXT(85, 420, "100%", 28, "��ҩʱ�䣺" + ColDate);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 12);
    /*LODOP.ADD_PRINT_TEXT(115, 20, "100%", 28, "�Ƶ��ˣ�" + User);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 12);
    LODOP.ADD_PRINT_TEXT(115, 400, "100%", 28, "��ӡʱ�䣺" + PrnDateTime);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 12);
    LODOP.ADD_PRINT_HTM(115,700,"100%",28,"<span tdata='pageNO'>��##ҳ</span> <span tdata='pageCount'>��##ҳ</span>");
    LODOP.SET_PRINT_STYLEA(0,"ItemType",1);*/
    var html = "<style>table,td,th {border: 1px solid black;border-style: solid;border-collapse: collapse;font-size:16px;} table{table-layout:fixed;display:table;} tfoot,th{ border:none;font-size:16px;}</style><table>";
    html +="<thead>";
    html += "<tr><td>" + "ҩƷ����" + "</td>"; 
    html += "<td>" + "���" + "</td>"; 
    html += "<td>" + "��ҩ����" + "</td>"; 
    html += "<td>" + "��λ" + "</td>"; 
    html += "<td>" + "�ܼ�" + "</td>";
    html += "<td>" + "ҽ����" + "</td>"; 
    html += "<td>" + "�����" + "</td>"; 
    html += "<td>" + "��λ����" + "</td></tr>";
    html +="</thead>";
    html += "<tbody>"; 
    for (var i = 0; i < colarray.rows.length; i++) {
        var printData = colarray.rows[i];
        html += "<tr>";
		html += "<td>" + printData.InciDesc + "</td>";
		html += "<td>" + printData.Spec + "</td>";
		html += "<td>" + printData.FacQty + "</td>";
		html += "<td>" + printData.StkBin + "</td>";
		html += "<td>" + printData.Amt + "</td>";
		html += "<td>" + printData.Qty + "</td>";
		html += "<td>" + printData.ResQty + "</td>";
		html += "<td>" + printData.bedInciTotal + "</td>";
        html += "</tr>";
    }
    html += "</tbody><tfoot>";
    html += "<tr>";
	html += "<th colspan='3'>" + "��ӡʱ�䣺" + PrnDateTime + "</th>";
	html += "<th colspan='1'>" + " "+ "</th>";
	html += "<th colspan='2'>" + "�Ƶ��ˣ�" + User + "</th>";
	html += "<th colspan='2'>" + "<span tdata='pageNO'>��##ҳ</span> <span tdata='pageCount'>��##ҳ</span>" + "</th>";
    html += "</tr>";
    html += "</tfoot></table>";
    html +=html;
    LODOP.ADD_PRINT_TABLE(145, 0, "100%", "100%", html);
    LODOP.PREVIEW();

}
//סԺ��ҩ��ϸ��(���)
function CreatDispDetailResPrint(LODOP,colarray,mainData){
	if(mainData==""){
		return;
	}
	var mainArr=mainData.split("^");
	var	HospitalDesc=tkMakeServerCall("web.DHCSTKUTIL","GetHospName",session['LOGON.HOSPID'])
	var Ward=mainArr[0];
	var DispNo=mainArr[1];
	var ColDate=mainArr[2];
	var ColTime=mainArr[6];
	var PhaType=mainArr[5];
	var User=mainArr[3];
	var PhaLoc=mainArr[4];
	var Priority=mainArr[7];
	var PrnDateTime=mainArr[8];
	var ResDetail=1 
	var ColDate=ColDate+" "+ColTime ;
    if (ResDetail==""){
	    return;
	}
    LODOP.PRINT_INIT("��ҩ�����ϸ��");
    LODOP.SET_PRINT_PAGESIZE(1, 0, 0, "A4");
    LODOP.ADD_PRINT_TEXT(15, 25, 600, 70, HospitalDesc+PhaLoc+"�����ϸ��"+"-"+Ward);
    LODOP.SET_PRINT_STYLEA(0, "FontName", "����");
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 12);
    LODOP.SET_PRINT_STYLEA(0, "Alignment", 2);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "Horient", 2);
    LODOP.ADD_PRINT_TEXT(55, 60, "100%", 28, "��ҩ���ţ�" + DispNo);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 12);
    LODOP.ADD_PRINT_TEXT(55, 420, "100%", 28, "��ҩ���뵥�ţ�" + PhaType);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 12);
    LODOP.ADD_PRINT_TEXT(85, 60, "100%", 28, "������" + Ward);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 12);
    LODOP.ADD_PRINT_TEXT(85, 420, "100%", 28, "��ҩʱ�䣺" + ColDate);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 12);
    /*LODOP.ADD_PRINT_TEXT(115, 20, "100%", 28, "�Ƶ��ˣ�" + User);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 12);
    LODOP.ADD_PRINT_TEXT(115, 400, "100%", 28, "��ӡʱ�䣺" + PrnDateTime);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 12);
    LODOP.ADD_PRINT_HTM(115,700,"100%",28,"<span tdata='pageNO'>��##ҳ</span> <span tdata='pageCount'>��##ҳ</span>");
    LODOP.SET_PRINT_STYLEA(0,"ItemType",1);*/
    var html = "<style>table,td,th {border: 1px solid black;border-style: solid;border-collapse: collapse;font-size:16px;} table{table-layout:fixed;display:table;} tfoot,th{ border:none;font-size:16px;}</style><table>";
    html +="<thead>";
    html += "<tr><td>" + "����" + "</td>";
    html += "<td>" + "�ǼǺ�" + "</td>";
    html += "<td>" + "����" + "</td>"; 
    html += "<td>" + "ҩƷ����" + "</td>"; 
    html += "<td>" + "���" + "</td>"; 
    html += "<td>" + "��������" + "</td>";
    html += "<td>" + "�������" + "</td></tr>"; 
    html +="</thead>";
    html += "<tbody>";
    for (var i = 0; i < colarray.rows.length; i++) {
        var printData = colarray.rows[i];
        html += "<tr>";
		html += "<td>" + printData.BedNo + "</td>";
		html += "<td>" + printData.PatNo + "</td>";
		html += "<td>" + printData.PatName + "</td>";
		html += "<td>" + printData.InciDesc + "</td>";
		html += "<td>" + printData.Spec + "</td>";
		html += "<td>" + printData.ReqQty + "</td>";
		html += "<td>" + printData.ResQty + "</td>";
        html += "</tr>";
    }
    html += "</tbody><tfoot>";
    html += "<tr>";
	html += "<th colspan='3'>" + "��ӡʱ�䣺" + PrnDateTime + "</th>";
	html += "<th colspan='1'>" + " "+ "</th>";
	html += "<th colspan='1'>" + "�Ƶ��ˣ�" + User + "</th>";
	html += "<th colspan='2'>" + "<span tdata='pageNO'>��##ҳ</span> <span tdata='pageCount'>��##ҳ</span>" + "</th>";
    html += "</tr>";
    html += "</tfoot></table>";
    html +=html;
    LODOP.ADD_PRINT_TABLE(145, 0, "100%", "100%", html);
    LODOP.PREVIEW();
}

//סԺ��ҩ��治��
function CreatNoStockDetailPrint(LODOP,colarray,mainData){
	var	HospitalDesc=tkMakeServerCall("web.DHCSTKUTIL","GetHospName",session['LOGON.HOSPID'])
    LODOP.PRINT_INIT("��ҩ��治����ϸ��");
    LODOP.SET_PRINT_PAGESIZE(1, 0, 0, "A4");
    LODOP.ADD_PRINT_TEXT(15, 25, 600, 70, HospitalDesc+"��治����ϸ��");
    LODOP.SET_PRINT_STYLEA(0, "FontName", "����");
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 14);
    LODOP.SET_PRINT_STYLEA(0, "Alignment", 2);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "Horient", 2);
    //LODOP.ADD_PRINT_HTM(45,700,"100%",28,"<span tdata='pageNO'>��##ҳ</span> <span tdata='pageCount'>��##ҳ</span>");
    //LODOP.SET_PRINT_STYLEA(0,"ItemType",1);
    var html = "<style>table,td,th {border: 1px solid black;border-style: solid;border-collapse: collapse;font-size:16px;} table{table-layout:fixed;display:table;} tfoot,th{ border:none;font-size:16px;}</style><table>";
    html +="<thead>";
    html += "<tr><td>" + "����" + "</td>";
    html += "<td>" + "����" + "</td>";
    html += "<td>" + "�ǼǺ�" + "</td>";
    html += "<td>" + "����" + "</td>"; 
    html += "<td>" + "�Ա�" + "</td>";
    html += "<td>" + "ҩƷ����" + "</td>"; 
    html += "<td>" + "���" + "</td>"; 
    html += "<td>" + "��λ" + "</td>";
    html += "<td>" + "����" + "</td></tr>"; 
    html +="</thead>";
    html += "<tbody>";
    for (var i = 0; i < colarray.rows.length; i++) {
        var printData = colarray.rows[i];
        html += "<tr>";
        html += "<td>" + printData.Ward + "</td>";
		html += "<td>" + printData.BedNo + "</td>";
		html += "<td>" + printData.PatNo + "</td>";
		html += "<td>" + printData.PatName + "</td>";
		html += "<td>" + printData.PatSex + "</td>";
		html += "<td>" + printData.InciDesc + "</td>";
		html += "<td>" + printData.Spec + "</td>";
		html += "<td>" + printData.Uom + "</td>";
		html += "<td>" + printData.Qty + "</td>";
        html += "</tr>";
    }
    html += "</tbody><tfoot>";
    html += "<tr>";
	html += "<th colspan='6'>" + " "+ "</th>";
	html += "<th colspan='3'>" + "<span tdata='pageNO'>��##ҳ</span> <span tdata='pageCount'>��##ҳ</span>" + "</th>";
    html += "</tr>";
    html += "</tfoot></table>";
    html +=html;
    LODOP.ADD_PRINT_TABLE(75, 0, "100%", "100%", html);
    LODOP.PREVIEW();
}

///סԺ��ҩ��ҩ��
function CreatDispCYPrint(LODOP,colarray,mainArr){
	var	HospitalDesc=tkMakeServerCall("web.DHCSTKUTIL","GetHospName",session['LOGON.HOSPID'])
	var mainArr=mainArr.split("||");
	var patstr=mainArr[0];  //����Ϣ
	var drgstr=mainArr[1];  //ҩƷ��ϸ
	var patArr=patstr.split("^");		
	var PrescNo=patArr[9];  //����
	var PatNo=patArr[0];    //�ǼǺ�
	var Ward=patArr[4];     //����
	var AdmLoc=patArr[8];   //�������
	var BedNo=patArr[7];    //����
	var PhaLoc=patArr[5];   //ҩ��
	var PatName=patArr[1];  //��������
	var PatSex=patArr[2];   //�Ա�
	var PatAge=patArr[3];   //����
	var Diagn=patArr[11];   //���
	var Doctor=patArr[10];  //ҽ��
	var FyName=patArr[6];   //��ҩ��
	var PyName=patArr[6];   //�����
	var Amt=patArr[20];     //������� //һ���ļ۸�
	var Factor=patArr[13];     //��������
	var AmtSum=(Amt*Factor).toFixed(2)
	var drgArr=drgstr.split("&");
	var tmpStr="";
	for(var n=1;n<=drgArr.length;n++){
		var drgStrArr=drgArr[n-1].split("^");
		var temp=drgStrArr[0]+"*"+drgStrArr[3]+";;";
		if(tmpStr==""){
			var tmpStr=temp;
		}else{
			tmpStr=tmpStr+temp;
		}
	}
    LODOP.PRINT_INIT("��ҩ��ϸ��");
    LODOP.SET_PRINT_PAGESIZE(1, 0, 0, "A4");
    LODOP.ADD_PRINT_TEXT(15, 25, 600, 70, HospitalDesc+"��ҩ����ǩ");
    LODOP.SET_PRINT_STYLEA(0, "FontName", "����");
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 14);
    LODOP.SET_PRINT_STYLEA(0, "Alignment", 2);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "Horient", 2);
    LODOP.ADD_PRINT_TEXT(55, 20, "100%", 28, "�����ţ�" + PrescNo);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 12);
    LODOP.ADD_PRINT_TEXT(55, 300, "100%", 28, "�ǼǺţ�" + PatNo);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 12);
    LODOP.ADD_PRINT_TEXT(55, 500, "100%", 28, "������ң�" + AdmLoc);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 12);
    LODOP.ADD_PRINT_TEXT(85, 20, "100%", 28, "������" + Ward);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 12);
    LODOP.ADD_PRINT_TEXT(85, 300, "100%", 28, "���ţ�" + BedNo);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 12);
    LODOP.ADD_PRINT_TEXT(85, 500, "100%", 28, "ҩ����" + PhaLoc);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 12);
    LODOP.ADD_PRINT_TEXT(115, 20, "100%", 28, "������" + PatName);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 12);
    LODOP.ADD_PRINT_TEXT(115, 300, "100%", 28, "�Ա�" + PatSex);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 12);
    LODOP.ADD_PRINT_TEXT(115, 500, "100%", 28, "���䣺" + PatAge);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 12);
    LODOP.ADD_PRINT_TEXT(145, 20, "100%", 28, "�ٴ���ϣ�" + Diagn);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 12);
    LODOP.ADD_PRINT_TEXT(145, 300, "100%", 28, "ҽʦ��" + Doctor);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 12);
    var html = "<style>table,td,th {border: 1px solid black;border-style: solid;border-collapse: collapse;font-size:16px;} table{table-layout:fixed;display:table;} tfoot,th{ border:none;font-size:16px;}</style><table>";
    html +="<thead>";
    html += "<tr><td colspan='1'>" + "Rp:" + "</td>";
    html += "<td colspan='2'>" + "" + "</td></tr>"; 
    html +="</thead>";
    html +="<tbody>";
	html += "<tr><td colspan='1'>" + "" + "</td>";
	html += "<td colspan='2'>" + tmpStr + "</td></tr>";
	html += "</tbody><tfoot>";
    html += "<tr>";
    html += "<th colspan='1'>" + "������" + Factor + "</th>";
	html += "<th colspan='1'>" + "ҩ�ѣ�" + Amt + "</th>";
	html += "<th colspan='1'>" + "" + "</th></tr>";
	html += "<tr>";
	html += "<th colspan='1'>" + "���/����ǩ��(ǩ��)��" + PyName + "</th>";
	html += "<th colspan='1'>" + "�˶�/��ҩǩ��(ǩ��)��" + FyName + "</th>";
	html += "<th colspan='1'>" + "<span tdata='pageNO'>��##ҳ</span> <span tdata='pageCount'>��##ҳ</span>"+ "</th></tr>";
	html += "<tr>";
	html += "<th colspan='3'>" + "ҩʦ��ʾ��1������ҽ����ҩ��2�����ڴ��ڵ���ҩƷ��3������������Ч��4������ҩƷ�����˻�"+ "</th>";
    html += "</tr>";
    html += "</tfoot></table>";
    html +=html;
    LODOP.ADD_PRINT_TABLE(175, 0, "100%", "100%", html);
    /*LODOP.ADD_PRINT_TEXT(320, 20, "100%", 28, "������" + Factor);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 12);
    LODOP.ADD_PRINT_TEXT(320, 300, "100%", 28, "ҩ�ѣ�" + Amt);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 12);
    LODOP.ADD_PRINT_HTM(320,700,"100%",28,"<span tdata='pageNO'>��##ҳ</span> <span tdata='pageCount'>��##ҳ</span>");
    LODOP.SET_PRINT_STYLEA(0,"ItemType",1);
    LODOP.ADD_PRINT_TEXT(350, 20, "100%", 28, "���/����ǩ��(ǩ��)��" + PyName);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 12);
    LODOP.ADD_PRINT_TEXT(350, 300, "100%", 28, "�˶�/��ҩǩ��(ǩ��)��" + FyName);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 12);
    LODOP.ADD_PRINT_TEXT(380, 20, "100%", 28, "ҩʦ��ʾ��1������ҽ����ҩ��2�����ڴ��ڵ���ҩƷ��3������������Ч��4������ҩƷ�����˻� ");
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);*/
    LODOP.PREVIEW();

}