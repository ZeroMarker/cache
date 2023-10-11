var DHCST =({

	// ��ʼ��ҵ�������������б�
    // dhcstcomboeu:scripts/dhcst/EasyUI/Plugins/dhcst.plugins.js
    ComboBox: {
        Init: function(_cOptions, _options) {
            DHCPHA_HUI_COM.ComboBox.Init(_cOptions, _options, "DHCST");
        },
        // ����ѡ��ڼ�����¼
        Select: function(_options) {
            //_options.Id
            //_options.Num
            var _id = _options.Id;
            var data = $('#' + _id).combobox('getData');
            if (data.length > 0) {
                $('#' + _id).combobox('select', data[_options.Num].RowId);
            }

        },
        // ������
        StkCat: {
            ClassName: 'web.DHCST.Common.JsCommon',
            QueryName: 'INCSCStkGrp',
            mode: "remote"
        },
        // ����
        Loc: {
            ClassName: 'web.DHCST.Common.JsCommon',
            QueryName: 'GetLocByGrp',
            grpdr:session['LOGON.GROUPID']
        },
        //�Ƽ�
        InRec: {
            ClassName: 'web.DHCST.Common.JsCommon',
            QueryName: 'GetInRecList',
            RecItmDesc:''
        },
        //��ȫ���µ���Ա
        UserOfGrp: {
            ClassName: 'web.DHCST.Common.JsCommon',
            QueryName: 'GetUserOfGrpList',
            grpdr:session['LOGON.GROUPID']
        },
        //��浥λ
        Uom:{
            ClassName: 'web.DHCST.Common.JsCommon',
            QueryName: 'GetUomByInci'
            
        },
       	InManuStatus:{
	    	data: [{ "RowId": "10", "Description": "δ���" }, { "RowId": "1", "Description": "�����" }]
	    }
    },
    ComboGrid: {
        Init: function(_cOptions, _options) {
            DHCPHA_HUI_COM.ComboGrid.Init(_cOptions, _options, "DHCST");
        },
        // �����ҩƷ
        IncItm: {
            QueryParams: {
                ClassName: "web.DHCST.Common.JsCommon",
                QueryName: "IncItm",
                inputParams: ""
            },
            panelWidth: 750,
            columns: [
                [
                    { field: 'incRowId', title: 'incItmRowId', width: 100, sortable: true, hidden: true },
                    { field: 'incCode', title: 'ҩƷ����', width: 100, sortable: true },
                    { field: 'incDesc', title: 'ҩƷ����', width: 400, sortable: true },
                    { field: 'incSpec', title: '���', width: 100, sortable: true }
                ]
            ],
            idField: 'incRowId',
            textField: 'incDesc'
        },
        InRec: {
            QueryParams: {
                ClassName: "web.DHCST.Common.JsCommon",
                QueryName: "GetInRecList",
                inputParams: ""
            },
            panelWidth: 750,
            columns: [
                [
                    { field: 'RowId', title: 'incItmRowId', width: 100, sortable: true, hidden: true },
                    { field: 'Description', title: '�Ƽ���', width: 150, sortable: true },
                    { field: 'Qty', title: '�Ƽ�����', width: 30, sortable: true },
                    { field: 'Uom', title: '��λ', width: 30, sortable: true },
                    { field: 'Remark', title: '��ע', width: 140, sortable: true },
                    { field: 'ExpDate', title: 'Ĭ��Ч��', width: 140, sortable: true, hidden: true },
                    { field: 'AddCost', title: '���ӷ���', width: 140, sortable: true, hidden: true }
                    
                ]
            ],
            idField: 'RowId',
            textField: 'Description'
        }
        /*,
        //��浥λ
        Uom: {
        	 QueryParams: {
	        	
	            ClassName: 'web.DHCST.Common.JsCommon',
	            QueryName: 'GetUomByInci',
	            inputParams:''
        	 },
        	 columns: [[
                    { field: 'RowId', title: 'RowId', width: 100, sortable: true, hidden: true },
                    { field: 'Description', title: '��λ', width: 100, sortable: true }
              ]]
              ,
            idField: 'RowId',
            textField: 'Description'
        }	*/
    },
    GridComboBox: {
        Init: function(_cOptions, _options) {
            return DHCPHA_HUI_COM.GridComboBox.Init(_cOptions, _options, "DHCST");
        }
    },
    GridComboGrid: {
        Init: function(_cOptions, _options) {
            return DHCPHA_HUI_COM.GridComboGrid.Init(_cOptions, _options, "DHCST");
        }
    },
	Progress: {
        Show: function(_options) {
            var _text = '  ��  ��  ��  ��  ��  ';
            var _type = _options.type;
            if (_type) {
                if (_type == "save") {
                    _text = '  ��  ��  ��  ��  ��';
                } else if (_type == 'print') {
                    _text = '  ��  ӡ  ��  ��  ��'
                } else if (_type == 'export') {
                    _text = '  ��  ��  ��  ��  ��'
                } else if (_type == 'delete') {
                    _text = '  ɾ  ��  ��  ��  ��'
                }
            }
            _text = $g(_text);
            $.messager.progress({
                title: '�����ĵȴ�...',
                text: _text,
                interval: _options.interval ? _options.interval : 1000
            })
        },
        Close: function() {
            $.messager.progress('close');
        }
    },
    // ��Ǭ����
    RunQianBG: "../csp/dhcst.blank.backgroud.csp",
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
        if (isPreview == 1) {
            fileName = raqName+ "&"+ params;
            if (isPath == 1) {
                if (typeof websys_writeMWToken !== 'undefined') {
                    return websys_writeMWToken("dhccpmrunqianreport.csp?reportName=" + fileName);
                }
                return "dhccpmrunqianreport.csp?reportName=" + fileName;
            } else {
                DHCCPM_RQPrint(fileName, window.screen.availWidth * 0.5, window.screen.availHeight);
            }
        } else {
            fileName = "{" + raqName + "(" + params + ")}";
            DHCCPM_RQDirectPrint(fileName);
        }
    }
})