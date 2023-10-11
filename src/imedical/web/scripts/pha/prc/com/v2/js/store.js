/**
 * ����:	 ��������-���ݼ�����
 * ��д��:	 MaYuqiang
 * ��д����: 2019-05-06
 */
PHA_COM.ResizePhaColParam.auto = false;		//�Զ�����pha-col���루false��������

var PRC_STORE = {
    Url: $URL + "?ResultSetType=Array&",	
    // ������ʽ
    PCNTSWay: function (type,wayType) {
		return {
            url: this.Url + "ClassName=PHA.PRC.Com.Store&QueryName=PCNTSWayStore&Type=" + type +"&WayType=" + wayType
        }
    },
	// �������Ʒ���(����ҩ�Ｖ��)
    PCNTSAntiLevel: function () {
        return this.Url + "ClassName=PHA.PRC.Com.Store&QueryName=PCNTSCtrlStore&hospID=" + PHA_COM.Session.HOSPID; 
    },
	// �����������Ʒ���
    PCNTSPoison: function () {
        return this.Url + "ClassName=PHA.PRC.Com.Store&QueryName=PCNTSPoisonStore&hospID=" + PHA_COM.Session.HOSPID; 
    },
	// ����ҩʦ 
    PhaUser: function () {
        return this.Url + "ClassName=PHA.PRC.Com.Store&QueryName=SelectPharmacist&hospID=" + PHA_COM.Session.HOSPID;   
    },
	// ������ʾֵ 
    Factor: function () {
        return this.Url + "ClassName=PHA.PRC.Com.Store&QueryName=PCNTSFactorStore&hospID=" + PHA_COM.Session.HOSPID;   
    },
	// ҩʦ���� 
    PhaAdvice: function () {
        return this.Url + "ClassName=PHA.PRC.Com.Store&QueryName=SelectAdviceStore&hospID=" + PHA_COM.Session.HOSPID;   
    },
	// ��ҩ�������� 
    HerbForm: function () { 
		return {
            url: this.Url + "ClassName=PHA.PRC.Com.Store&QueryName=SelectHerbForm"
        }
    },
	// �����п�����
    BldType: function () { 
		return this.Url + "ClassName=PHA.PRC.Com.Store&QueryName=SelectBldTypeStore"
    },
	// ��������
    Operation: function (bldIdStr,qText) { 
		return this.Url + "ClassName=PHA.PRC.Com.Store&QueryName=SelectOrcOperStore&BldIdStr=" + bldIdStr + "&qText=" + qText
    },
	// ��Ǭ����
    RunQianBG: "../csp/dhcst.blank.backgroud.csp",
    // ҽԺ������
	AddHospCom: function (_options) {
        var tableName = _options.tableName || '';
        if (tableName === '') {
            $.messager.alert('��ʾ', '�������,δ����Ȩ���������', 'error');
            return;
        }
        var hospAutFlag = tkMakeServerCall('PHA.FACE.IN.Com', 'GetHospAut');
        if (hospAutFlag === 'Y') {
            $($('body>.hisui-layout')[0]).layout('add', {
                region: 'north',
                border: false,
                height: 40,
                split: false,
                bodyCls: 'pha-ly-hosp',
                content:
                    '<div style="padding-left:10px;">' +
                    '   <div class="pha-row">' +
                    '       <div class="pha-col">' +
                    '           <label id="_HospListLabel">'+$g("ҽԺ")+'</label>' +
                    '       </div>' +
                    '   	<div class="pha-col">' +
                    '       	<input id="_HospList" class="textbox"/>' +
                    '   	</div>' +
                    '	</div>' +
                    '</div>'
            });
            var genHospObj = GenHospComp(tableName);
            return genHospObj;
        } else {
            return '';
        }
    }
	

}

var PRCPRINT = ({
	/// �޸�Ϊ��Ǭraq·��,ע��ͬʱ������Ǭ�ļ�
    /// _option.raqName:   ��Ǭ�ļ���
    /// _options.raqParams:������Ϣ
    /// _options.isPreview:�Ƿ�Ԥ��(1:��)
    /// _options.isPath:   �Ƿ����ȡ·��(1:��)
    RaqPrint: function(_options) {
        var raqName = _options.raqName;
        var raqParams = _options.raqParams;
        var isPreview = _options.isPreview;
        var isPath = _options.isPath;
        var raqSplit = (isPreview == 1 ? "&" : ";");
        var fileName = "";
        var params = "";
        var paramsI = 0;
        for (var param in raqParams) {
            var iParam = raqParams[param];
            var iParamStr = param + "=" + iParam;
            if (paramsI == 0) {
                params = iParamStr;
            } else {
                params = params + raqSplit + iParamStr;
            }
            paramsI++;
        }
        var rqDTFormat = this.RQDTFormat();
        if (isPreview == 1) {
            fileName = raqName + "&RQDTFormat=" + rqDTFormat + "&" + params;
            if (isPath == 1) {
                if (typeof websys_writeMWToken !== 'undefined') {
                    return websys_writeMWToken("dhccpmrunqianreport.csp?reportName=" + fileName);
                }
                return "dhccpmrunqianreport.csp?reportName=" + fileName;
            } else {
                DHCCPM_RQPrint(fileName, window.screen.availWidth * 0.5, window.screen.availHeight);
            }
        } else {
            fileName = "{" + raqName + "(" + params + ";RQDTFormat=" + rqDTFormat + ")}";
            DHCCPM_RQDirectPrint(fileName);
        }
    },
    // ϵͳ���ڸ�ʽ,��Ǭ��ӡ��
    RQDTFormat: function() {
        var dateFmt = "yyyy-MM-dd"
        var fmtDate = $.fn.datebox.defaults.formatter(new Date());
        if (fmtDate.indexOf("/") >= 0) {
            dateFmt = "dd/MM/yyyy"
        }
        return dateFmt ;
    }
});

function InitSetPatInfo(type){
    if (typeof type === "undefined"){
        var type = "";
    }
    if (type === "I"){
        var emptyMsg = $g("����ѡ��һ������");
    } else {
        var emptyMsg = $g("����ѡ��һ������");
	}
	$('#patImg').attr("class", "pic-pat-unknown-gender");
    $('#patText').width($('#patText').parent().parent().width() - 45);
    $('#patText').text(emptyMsg);
}

function LoadPatInfo(rowData){
    var patordinfo='';
    var prescNo = rowData.prescNo ;
    var patNo = rowData.patNo ;
    var patName = rowData.patName ;
    var sexDesc = rowData.sexDesc ;
    var patAge = rowData.patAge ;
    var typeDesc = rowData.typeDesc ;		//���߷ѱ�
    var doclocDesc = rowData.doclocDesc ;	//�������
    var patDiag = "��ϣ�"+rowData.diag ;	//�������
    var imageid="";
    if (sexDesc=="Ů"){  
        imageid="pic-pat-woman";
    }else if (sexDesc=="��"){
        imageid="pic-pat-man";
    }else{
        imageid="pic-pat-unknown-gender";
    }
           
    patordinfo = patName + delimiter();
    patordinfo += prescNo ? prescNo + delimiter() : "";
    patordinfo += patNo + delimiter();
    patordinfo += $g(sexDesc) + delimiter();
    patordinfo += patAge + delimiter();
    patordinfo += $g(typeDesc) + delimiter();
    patordinfo += doclocDesc + delimiter();
    patordinfo += '<span id="patDiag">'+ patDiag +'</span>';
    $('#patImg').attr("class", imageid);

    $('#patText').html(patordinfo);

	$("#patDiag").tooltip({
        content: $("#patDiag").text(),
        position: 'bottom',
        showDelay: 500
	});
}

function delimiter(){
    return '<span style="color:#bbb;">&nbsp;&nbsp;/&nbsp;&nbsp;</span>';
}