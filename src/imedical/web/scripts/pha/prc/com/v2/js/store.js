/**
 * ����:	 ��������-���ݼ�����
 * ��д��:	 MaYuqiang
 * ��д����: 2019-05-06
 */
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
        return this.Url + "ClassName=PHA.PRC.Com.Store&QueryName=PCNTSCtrlStore"
    },
	// �����������Ʒ���
    PCNTSPoison: function () {
        return this.Url + "ClassName=PHA.PRC.Com.Store&QueryName=PCNTSPoisonStore"
    },
	// ����ҩʦ 
    PhaUser: function () {
        return this.Url + "ClassName=PHA.PRC.Com.Store&QueryName=SelectPharmacist"   
    },
	// ������ʾֵ 
    Factor: function () {
        return this.Url + "ClassName=PHA.PRC.Com.Store&QueryName=PCNTSFactorStore"   
    },
	// ҩʦ���� 
    PhaAdvice: function () {
        return this.Url + "ClassName=PHA.PRC.Com.Store&QueryName=SelectAdviceStore"   
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