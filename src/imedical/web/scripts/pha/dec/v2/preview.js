/**
ģ��:		ҩ������
��ģ��:		ҩ������-����Ԥ��
Creator:	hulihua
CreateDate:	2019-07-11
preview.js
*/
var DEC_PRESC = {
	//����,���ڲ�ҩ��ҳ
	Row: "",
	//Ԥ������߶�
	Height: "",
	//����ɫ
	Background: "#FFFFFF",
	//��ҩ��־
	/**
	 * Layout ��������Ԥ��panel
	 * @param {String} _Id : ��Ԫ�ص�id
	 * @param {Object} _opts panel���Խ�����Ĭ������
	 * 				   	_opts.divId ��ʾ������Ϣ��div��id
	 * @return {String} ������������ʾ��Ϣ��Ԫ��id������Ԥ����Ϣʱ��Ϊ����	
	 */
	Layout: function(_Id, _opts) {
		if(!_Id){
			return;	
		}
		_opts = _opts || {};
		if(parseInt(_opts.width)>0) { 	//mm��λת��px
			_opts.width = (new unitConversion().mmConversionPx(parseInt(_opts.width)));
		}else{
			_opts.width = 700;
		}
		var _conHtmlId = _opts.divId || "divPreLayout";
		var _defOpts = {
			region: 'west',
		    split: true,
		    headerCls: 'panel-header-gray',
		    bodyCls: 'panel-body-gray',
		    iconCls: 'icon-paper',
		    width: 700,
		    title: "����Ԥ��",
		    content: '<div id="' + _conHtmlId + '"></div>'
		}
		var nOpts = $.extend({}, _defOpts, _opts)
		$('#'+_Id).layout('add', nOpts);
		return _conHtmlId;
	},
	/**
	 * Presc ����Ԥ����ʾ
	 * @param {String} _Id : ������ʾ��htmlԪ��id
	 * @param {Object} _opts 
	 *					_opts.PrescNo : ������
	 *					_opts.AdmType : �������ͣ�I/O��
	 *					_opts.PrtType : ����(Ԥ��/��ӡ),��ȱʡ,Ĭ��ΪԤ��
	 *					_opts.zf : ����/�׷�,Ĭ�ϵ׷�
	 *					_opts.CY : ����/�׷�,Ĭ�ϵ׷�
	 */
	Presc: function(_Id, _opts){
		DEC_PRESC.Clear(_Id);
		var _data = DEC_PRESC.Data(_opts);
		if(_data == null){ return; }
		if($.isEmptyObject(_data)) {return;}
		if(_data.msg) { 
			DEC_PRESC.Error(_Id, _data);
			return; 
		}
		var _tmpList = _data.List;
		var _page = 1;
		while(_tmpList.length > 0){
			_data.List = _tmpList.splice(0, DEC_PRESC.Row)
			DEC_PRESC.View(_Id, _data, _page);
			_page++;
		}
	},
	/**
	 * Data ��ȡ����,������Ĭ��ֵ
	 * @param {Object} _opts : ������ʾ������
	 */
	Data: function(_opts){
		var _prescNo = _opts.PrescNo;
		var _prtType = _opts.PrtType || "DISPPREVIEW";
		var _zf = _opts.zf || "�׷�";
		var _data;
		if((_opts.AdmType == "I")||(_prescNo.indexOf("I")>-1)){
			_data = DEC_PRESC.InData(_prescNo, _prtType, _zf);
		}else{
			_data = DEC_PRESC.OutData(_prescNo, _prtType, _zf);
		}
		if($.isEmptyObject(_data)) {return null;}
		if(_data.msg) {return _data;}
		if (_data.Templet.indexOf("Ver")<0){
			DEC_PRESC.Height="550px";
			DEC_PRESC.Row=12;
		}else{
			DEC_PRESC.Height="720px";
			DEC_PRESC.Row=16;
		}
		if(_opts.CY != "Y"){
			DEC_PRESC.Row = _data.List.length;
		}
		var _title = _data.Para.PrescTitle;
		if(_title.indexOf("����")>"-1"){
			DEC_PRESC.Background="#F5A89A";
	    }else if(_title.indexOf("����")>"-1"){
			DEC_PRESC.Background="#90EE90";
	    }else if(_title.indexOf("����")>"-1"){
			DEC_PRESC.Background="#FFFF96";
	    }
		return _data;
	},
	/**
	 * Presc ��ȡ���ﴦ������
	 * @param {String} _prescNo :������
	 * @param {String} _prtType : ����(Ԥ��/��ӡ)
	 * @param {String} _zf : ����/�׷�
	 * @return {Object} ��������
	 */
	OutData: function(_prescNo, _prtType, _zf){
		var _data = $cm({
			ClassName: "PHA.OP.COM.Print",
			MethodName: "PrescPrintData",
			PrescNo: _prescNo,
			ZfFlag: _zf,
			PrtType: _prtType,
			dataType: "json"
		}, false )
		return _data;
	},
	/**
	 * Presc ��ȡסԺ��������
	 * @param {String} _prescNo :������
	 * @param {String} _prtType : ����(Ԥ��/��ӡ)
	 * @param {String} _zf : ����/�׷�
	 * @return {Object} ��������
	 */
	InData: function(_prescNo, _prtType, _zf){
		var _data = $cm({
			ClassName: "web.DHCINPHA.Common.Print",
			MethodName: "PrescPrintData",
			PrescNo: _prescNo,
			ZfFlag: _zf,
			PrtType: _prtType,
			dataType: "json"
		}, false )
		return _data;
	},
	/**
	 * Clear �������Ԥ����ʾ
	 * @param {String} _Id : ������ʾ��htmlԪ��id
	 */
	Clear: function(_Id){
		$("#"+ _Id).html("");
	},
	/**
	 * Presc ʵ�ִ���Ԥ��
	 * @param {String} _Id : ������ʾ��htmlԪ��id
	 * @param {Object} _data : ������ʾ������
	 * @param {String} _page : ��ҩ��ҳ��,��ȱʡ
	 */
	View: function(_Id, _data, _page){
		if(!_page) { _page = 1 ;}
		var _tmpDivId = "divPreReport" + _page;
		var _htmlStr = "<div style='position:relative;height:" ;
			_htmlStr += DEC_PRESC.Height +";background:"
			_htmlStr += DEC_PRESC.Background +";' id=" + _tmpDivId + "></div>";
		$("#"+ _Id).append(_htmlStr); 
		var _prescHtml=DHCSTXMLPrint_Preview.JsonToHtml(_data);
		$("#"+ _tmpDivId).html(_prescHtml);
	},
	/**
	 * Error ������Ϣ��ʾ
	 * @param {String} _Id : ������ʾ��htmlԪ��id
	 * @param {Object} _data : ������ʾ������
	 */
	Error: function(_Id, _data){
		var _htmlStr = "<h1>" + _data.msg + "</h1>"
		$("#"+ _Id).append(_htmlStr); 
	}
}

//Ԥ������
function PrescView(PrePrescParamStr,prtType){
	if(document.getElementById("divPreLayout")==null){ return; }
	var PrePrescParamStrArr=PrePrescParamStr.split("^");
	var preAdmType=PrePrescParamStrArr[0]||"";
	var prescNo=PrePrescParamStrArr[1]||"";
	var cyFlag=PrePrescParamStrArr[2]||"";
	var prtData="{}";
	//�����סԺ���ݷֿ��Ա��Ժ����չ�Ը�ǿ
	if(preAdmType=="DHCINPHA"){
		prtData=tkMakeServerCall("web.DHCINPHA.Common.Print","PrescPrintData",prescNo,"�׷�",prtType);
	}else{
		prtData=tkMakeServerCall("PHA.OP.COM.Print","PrescPrintData",prescNo,"�׷�",prtType);
	}
	if (prtData=="{}"){
		return;
	}
	$("#divPreLayout").html("");
	var prtJson=JSON.parse(prtData);
	var newPrtJson={}
	$.extend(newPrtJson,prtJson);
	// �ǲ�ҩ
	if (cyFlag!="Y"){
		var prescHtml=DHCSTXMLPrint_Preview.JsonToHtml(newPrtJson);
		$("#divPreReport").html(prescHtml);
	}else{
		// ��ҩ����ǩ�߶��Լ�ÿҳlist����
		var templetCode=prtJson.Templet;
		if (templetCode.indexOf("Ver")<0){
			var PreViewHeight="550px";
			var cyListLimit=12;
		}else{
			var PreViewHeight="720px";
			var cyListLimit=16;
		}
		var prescTitle=prtJson.Para.PrescTitle;
		var prtList=prtJson.List;
		var prtListLen=prtList.length;
		// �����ҳ
		newPrtJson.List=[];
		var pageInt=parseInt(prtListLen/cyListLimit);
		var pageRem=prtListLen%cyListLimit;
		if (pageRem>0){
			pageInt++;
		}
		for (var pageI=0;pageI<pageInt;pageI++){
			// ȡList
			var newPrtList=[];
			var start=pageI*cyListLimit;
			var end=start+cyListLimit;
			newPrtList=prtList.slice(start,end);
			//newPrtList = newPrtList.slice(0,1)
			newPrtJson.List=newPrtList;
			var prescHtml=DHCSTXMLPrint_Preview.JsonToHtml(newPrtJson);
			var divLayOut = document.getElementById("divPreLayout");
			var newdiv = document.createElement("div");
			newdiv.id="divPreReport"+pageI;
			newdiv.style.position="relative";
			newdiv.style.height=PreViewHeight;		
			if(prescTitle.indexOf("����")>"-1"){
				newdiv.style.background="#F5A89A";
		    }else if(prescTitle.indexOf("����")>"-1"){
				newdiv.style.background="#90EE90";
		    }else if(prescTitle.indexOf("����")>"-1"){
				newdiv.style.background="#FFFF96";
		    }
			divLayOut.appendChild(newdiv);
			$("#divPreReport"+pageI).html(prescHtml);	
		}
	}
};

/**
 *���غͺ��׻�ת 
 *	new unitConversion().mmConversionPx(50)
 *	new unitConversion().pxConversionMm(50)
 */
function unitConversion() {
    /**
     * ��ȡDPI
     * @returns {Array}
     */
    this.conversion_getDPI =function () {
        var arrDPI = new Array;
        if (window.screen.deviceXDPI) {
            arrDPI[0] = window.screen.deviceXDPI;
            arrDPI[1] = window.screen.deviceYDPI;
        } else {
            var tmpNode = document.createElement("DIV");
            tmpNode.style.cssText = "width:1in;height:1in;position:absolute;left:0px;top:0px;z-index:99;visibility:hidden";
            document.body.appendChild(tmpNode);
            arrDPI[0] = parseInt(tmpNode.offsetWidth);
            arrDPI[1] = parseInt(tmpNode.offsetHeight);
            tmpNode.parentNode.removeChild(tmpNode);
        }
        return arrDPI;
    };
    /**
     * pxת��Ϊmm
     * @param value
     * @returns {number}
     */
    this.pxConversionMm = function (value) {
        var inch = value/this.conversion_getDPI()[0];
        var c_value = inch * 25.4;
        return c_value;
    };
    /**
     * mmת��Ϊpx
     * @param value
     * @returns {number}
     */
    this.mmConversionPx = function (value) {
        var inch = value/25.4;
        var c_value = inch*this.conversion_getDPI()[0];
        return c_value;
    }
}