var DHCST =({

	// 初始化业务界面各种下拉列表
    // dhcstcomboeu:scripts/dhcst/EasyUI/Plugins/dhcst.plugins.js
    ComboBox: {
        Init: function(_cOptions, _options) {
            DHCPHA_HUI_COM.ComboBox.Init(_cOptions, _options, "DHCST");
        },
        // 设置选择第几条记录
        Select: function(_options) {
            //_options.Id
            //_options.Num
            var _id = _options.Id;
            var data = $('#' + _id).combobox('getData');
            if (data.length > 0) {
                $('#' + _id).combobox('select', data[_options.Num].RowId);
            }

        },
        // 库存分类
        StkCat: {
            ClassName: 'web.DHCST.Common.JsCommon',
            QueryName: 'INCSCStkGrp',
            mode: "remote"
        },
        // 科室
        Loc: {
            ClassName: 'web.DHCST.Common.JsCommon',
            QueryName: 'GetLocByGrp',
            grpdr:session['LOGON.GROUPID']
        },
        //制剂
        InRec: {
            ClassName: 'web.DHCST.Common.JsCommon',
            QueryName: 'GetInRecList',
            RecItmDesc:''
        },
        //安全组下的人员
        UserOfGrp: {
            ClassName: 'web.DHCST.Common.JsCommon',
            QueryName: 'GetUserOfGrpList',
            grpdr:session['LOGON.GROUPID']
        },
        //库存单位
        Uom:{
            ClassName: 'web.DHCST.Common.JsCommon',
            QueryName: 'GetUomByInci'
            
        },
       	InManuStatus:{
	    	data: [{ "RowId": "10", "Description": "未审核" }, { "RowId": "1", "Description": "已审核" }]
	    }
    },
    ComboGrid: {
        Init: function(_cOptions, _options) {
            DHCPHA_HUI_COM.ComboGrid.Init(_cOptions, _options, "DHCST");
        },
        // 库存项药品
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
                    { field: 'incCode', title: '药品代码', width: 100, sortable: true },
                    { field: 'incDesc', title: '药品名称', width: 400, sortable: true },
                    { field: 'incSpec', title: '规格', width: 100, sortable: true }
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
                    { field: 'Description', title: '制剂名', width: 150, sortable: true },
                    { field: 'Qty', title: '制剂数量', width: 30, sortable: true },
                    { field: 'Uom', title: '单位', width: 30, sortable: true },
                    { field: 'Remark', title: '备注', width: 140, sortable: true },
                    { field: 'ExpDate', title: '默认效期', width: 140, sortable: true, hidden: true },
                    { field: 'AddCost', title: '附加费用', width: 140, sortable: true, hidden: true }
                    
                ]
            ],
            idField: 'RowId',
            textField: 'Description'
        }
        /*,
        //库存单位
        Uom: {
        	 QueryParams: {
	        	
	            ClassName: 'web.DHCST.Common.JsCommon',
	            QueryName: 'GetUomByInci',
	            inputParams:''
        	 },
        	 columns: [[
                    { field: 'RowId', title: 'RowId', width: 100, sortable: true, hidden: true },
                    { field: 'Description', title: '单位', width: 100, sortable: true }
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
            var _text = '  数  据  处  理  中  ';
            var _type = _options.type;
            if (_type) {
                if (_type == "save") {
                    _text = '  保  存  数  据  中';
                } else if (_type == 'print') {
                    _text = '  打  印  数  据  中'
                } else if (_type == 'export') {
                    _text = '  另  存  数  据  中'
                } else if (_type == 'delete') {
                    _text = '  删  除  数  据  中'
                }
            }
            _text = $g(_text);
            $.messager.progress({
                title: '请耐心等待...',
                text: _text,
                interval: _options.interval ? _options.interval : 1000
            })
        },
        Close: function() {
            $.messager.progress('close');
        }
    },
    // 润乾背景
    RunQianBG: "../csp/dhcst.blank.backgroud.csp",
   /// 修改为润乾raq路径,注意同时引入润乾文件
    /// _option.raqName:   润乾文件名
    /// _options.raqParams:参数信息
    /// _options.isPreview:是否预览(1:是)
    /// _options.isPath:   是否仅获取路径(1:是)
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