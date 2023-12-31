var templateConfig = {
    defaultPage: {
        "Code": "Page1",
        "Desc": "第2页",
        "PageNo": 2
    },

    defaultImage: {
        "Code":"defaultImage", 
        "Desc": "图片项", 
        "Type": "img",
        "DisplayRect": {"left":150,"top":10,"width":60,"height":60}, 
        "URL":""
    },

    defaultSignImage: {
        "Code":"defaultSignImage", 
        "Desc": "图片签名项", 
        "Type": "imgsign",
        "Editable": true,
        "DisplayRect": {"left":150,"top":10,"width":60,"height":60},
        "SignType": ""
    },

    defaultTitle: {
        "Code":"title", 
        "Desc": "标题", 
        "BorderLine": true,
        "DisplayRect": {"left":10,"top":10,"width":775,"height":60},
        "StyleCode": "TitleStyle"
    },

    defaultArea: {
        "Code": "displayArea", 
        "Desc":"区域", 
        "BorderLine": true,
        "DisplayRect": {"left":10,"top":160,"width":775,"height":80},
        "DrawAreaTitle" : false,
        "AreaTitleDirection" : "left",
        "CharSpace": "1.2",
        "AreaTitleWidth": "",
        "StyleCode": "AreaStyle"
    },

    defaultLeftArea: {
        "Code": "displayArea", 
        "Desc":"左区域", 
        "BorderLine": true,
        "DisplayRect": {"left":10,"top":160,"width":775,"height":80},
        "DrawAreaTitle" : true,
        "AreaTitleDirection" : "left",
        "CharSpace": "1.2",
        "AreaTitleWidth": "",
        "StyleCode": "AreaStyle"
    },

    defaultTopArea: {
        "Code": "displayArea", 
        "Desc":"上区域", 
        "BorderLine": true,
        "DisplayRect": {"left":10,"top":160,"width":775,"height":80},
        "DrawAreaTitle" : true,
        "AreaTitleDirection" : "top",
        "CharSpace": "1.2",
        "AreaTitleWidth": "",
        "StyleCode": "AreaStyle"
    },

    defaultRightArea: {
        "Code": "displayArea", 
        "Desc":"右区域", 
        "BorderLine": true,
        "DisplayRect": {"left":10,"top":160,"width":775,"height":80},
        "DrawAreaTitle" : true,
        "AreaTitleDirection" : "right",
        "CharSpace": "1.2",
        "AreaTitleWidth": "",
        "StyleCode": "AreaStyle"
    },

    defaultBottomArea: {
        "Code": "displayArea", 
        "Desc":"下区域", 
        "BorderLine": true,
        "DisplayRect": {"left":10,"top":160,"width":775,"height":80},
        "DrawAreaTitle" : true,
        "AreaTitleDirection" : "bottom",
        "CharSpace": "1.2",
        "AreaTitleWidth": "",
        "StyleCode": "AreaStyle"
    },

    defaultTextboxAreaItem: {
        "Code": "textboxItem", 
        "Desc": "文本框", 
        "Type": "textbox", 
        "UnderLine": true,
        "Editable": true,
        "Required": false,
        "DefaultValue": "",
        "ValueFromSchedule": "",
        "Formula": "",
        "Unit":"",
        "OnValueChanged": "",
        "DataEditView": "",
        "DisplayRect": {"left":20,"top":170,"width":80,"height":20},
        "StyleCode": "AreaItemStyle"
    },

    defaultCheckboxAreaItem: {
        "Code": "checkboxItem", 
        "Desc": "选择框", 
        "Type": "checkbox", 
        "Editable": true,
        "Required": false,
        "Group": "", 
        "Multiple": true,
        "ScoreValue": 0,
        "DefaultValue": false,
        "OnValueChanged": "",
        "CheckboxAlign": "left",
        "DisplayRect": {"left":20,"top":170,"width":80,"height":20},
        "StyleCode": "AreaItemStyle"
    },

    defaultComboboxAreaItem: {
        "Code": "comboboxItem", 
        "Desc": "组合框", 
        "Type": "combobox", 
        "UnderLine": true,
        "Editable": true,
        "Required": false,
        "Options": "",
        "ClassName": "",
        "QueryName": "",
        "QueryParams": "",
        "ValueField": "",
        "TextField": "",
        "Multiple": false,
        "DefaultValue": "",
        "ValueFromSchedule": "",
        "Unit":"",
        "OnValueChanged": "",
        "DisplayRect": {"left":20,"top":170,"width":80,"height":20},
        "StyleCode": "AreaItemStyle"
    },

    defaultHorizontalTextboxAreaItem: {
        "Code": "textboxItem", 
        "Desc": "横向文本", 
        "Type": "textbox", 
        "UnderLine": false,
        "Editable": false,
        "TextDirection": "Horizontal",
        "DisplayRect": {"left":20,"top":170,"width":80,"height":20},
        "StyleCode": "AreaItemStyle"
    },

    defaultVerticalTextboxAreaItem: {
        "Code": "textboxItem", 
        "Desc": "竖向文本", 
        "Type": "textbox", 
        "UnderLine": false,
        "Editable": false,
        "TextDirection": "Vertical",
        "CharSpace": "1.2",
        "DisplayRect": {"left":20,"top":170,"width":80,"height":20},
        "StyleCode": "AreaItemStyle"
    },

    defaultSignatureAreaItem: {
        "Code": "signatureItem", 
        "Desc": "签名", 
        "Type": "signature", 
        "UnderLine": true,
        "Editable": true,
        "Required":false,
        "DisplayRect": {"left":20,"top":170,"width":80,"height":20},
        "ImageOffsetX": 50,
        "ImageOffsetY": 0,
        "ImageWidth": 100,
        "ImageHeight": 30,
        "UserSign": false,
        "StyleCode": "AreaItemStyle"
    },

    defaultQrCode: {
        "Code": "qrCode", 
        "Desc": "二维码", 
        "Type": "qrCode", 
        "DisplayRect": {"left":20,"top":170,"width":80,"height":20},
        "DefaultValue": "123456",
        "ValueFromSchedule": ""
    },

    defaultBarCode: {
        "Code": "barCode", 
        "Desc": "条形码", 
        "Type": "barCode", 
        "DisplayRect": {"left":20,"top":170,"width":80,"height":20},
        "DefaultValue": "123456",
        "ValueFromSchedule": ""
    },

    defaultDateboxAreaItem: {
        "Code": "dateboxItem", 
        "Desc": "日期框", 
        "Type": "datebox", 
        "UnderLine": true,
        "Editable": true,
        "Required":false,
        "DefaultValue": "",
        "DisplayRect": {"left":20,"top":170,"width":80,"height":20},
        "StyleCode": "AreaItemStyle"
    },

    defaultDatetimeboxAreaItem: {
        "Code": "datetimeboxItem", 
        "Desc": "日期时间框", 
        "Type": "datetimebox", 
        "UnderLine": true,
        "Editable": true,
        "Required":false,
        "DefaultValue": "",
        "ValueFromSchedule": "",
        "DisplayRect": {"left":20,"top":170,"width":80,"height":20},
        "StyleCode": "AreaItemStyle"
    },

    defaultTimespinnerAreaItem: {
        "Code": "timespinnerItem", 
        "Desc": "时间框", 
        "Type": "timespinner", 
        "UnderLine": true,
        "Editable": true, 
        "Required":false,
        "DefaultValue": "",
        "DisplayRect": {"left":20,"top":170,"width":80,"height":20},
        "StyleCode": "AreaItemStyle"
    },

    defaultTextareaAreaItem: {
        "Code": "textareaItem", 
        "Desc": "多行文本框", 
        "Type": "textarea", 
        "UnderLine": false,
        "Editable": true,
        "Required":false,
        "DefaultValue": "",
        "ValueFromSchedule": "",
        "DataEditView": "",
        "DisplayRect": {"left":20,"top":170,"width":80,"height":20},
        "StyleCode": "AreaItemStyle"
    },

    defaultNumberspinnerAreaItem: {
        "Code": "numberspinnerItem", 
        "Desc": "数字框", 
        "Type": "numberspinner", 
        "UnderLine": true,
        "Editable": true, 
        "Required":false,
        "Formula": "",
        "Min":"",
        "Max":"",
        "Precision":"",
        "Unit":"",
        "OnValueChanged": "",
        "DisplayRect": {"left":20,"top":170,"width":80,"height":20},
        "StyleCode": "AreaItemStyle"
    },

    defaultTable: {
        "Code": "displayTable1", 
        "Desc":"表格", 
        "DisplayRect":{"left":10,"top":410,"width":775,"height":150}, 
        "StyleCode": "TableStyle",
        "RowCount": 6,
        "HeaderHeight": 0,
        "Columns":[
            {"ColumnCode": "Column1", "ColumnDesc":"列1", "RelativeWidth":100, "Type":""},
            {"ColumnCode": "Column2", "ColumnDesc":"列2", "RelativeWidth":100, "Type":""},
            {"ColumnCode": "Column3", "ColumnDesc":"列3", "RelativeWidth":100, "Type":""},
            {"ColumnCode": "Column4", "ColumnDesc":"列4", "RelativeWidth":100, "Type":""},
            {"ColumnCode": "Column5", "ColumnDesc":"列5", "RelativeWidth":100, "Type":""},
            {"ColumnCode": "Column6", "ColumnDesc":"列6", "RelativeWidth":100, "Type":""}
        ]
    },

    defaultHorizontalLine: {
        "Code": "horizontalLine", 
        "Desc": "横线", 
        "DisplayRect": {"left":10,"top":410,"width":775,"height":10},
        "LineType": "Horizontal",
        "LineDashed": false
    },

    defaultVerticalLine: {
        "Code": "verticalLine", 
        "Desc": "竖线", 
        "DisplayRect": {"left":10,"top":410,"width":10,"height":700},
        "LineType": "Vertical",
        "LineDashed": false
    },

    defaultComplexTable: {
        "Code": "complexTable1", "Desc":"表格区域", "DisplayRect":{"left":10,"top":600,"width":500,"height":150}, "StyleCode": "TableStyle",
        "TableInfo" : {
            "Rows": [
                {"RowIndex": 1, "RowHeight": 30},
                {"RowIndex": 2, "RowHeight": 30},
                {"RowIndex": 3, "RowHeight": 30}
            ],
            "Cols":[
                {"ColIndex": 1, "ColWidth": 100},
                {"ColIndex": 2, "ColWidth": 100},
                {"ColIndex": 3, "ColWidth": 100}
            ],
            "Cells":[
                {
                    "RowIndex": 1, "ColIndex": 1, "IsMergeCells": false, "FromRowIndex":1, "ToRowIndex":1, "FromColIndex":1, "ToColIndex":1, "AreaItems": []
                },
                {
                    "RowIndex": 1, "ColIndex": 2, "IsMergeCells": false, "FromRowIndex":1, "ToRowIndex":1, "FromColIndex":2, "ToColIndex":2, "AreaItems": []
                },
                {
                    "RowIndex": 1, "ColIndex": 3, "IsMergeCells": false, "FromRowIndex":1, "ToRowIndex":1, "FromColIndex":3, "ToColIndex":3, "AreaItems": []
                },
                {
                    "RowIndex": 2, "ColIndex": 1, "IsMergeCells": false, "FromRowIndex":2, "ToRowIndex":2, "FromColIndex":1, "ToColIndex":1, "AreaItems": []
                },
                {
                    "RowIndex": 2, "ColIndex": 2, "IsMergeCells": false, "FromRowIndex":2, "ToRowIndex":2, "FromColIndex":2, "ToColIndex":2, "AreaItems": []
                },
                {
                    "RowIndex": 2, "ColIndex": 3, "IsMergeCells": false, "FromRowIndex":2, "ToRowIndex":2, "FromColIndex":3, "ToColIndex":3, "AreaItems": []
                },
                {
                    "RowIndex": 3, "ColIndex": 1, "IsMergeCells": false, "FromRowIndex":3, "ToRowIndex":3, "FromColIndex":1, "ToColIndex":1, "AreaItems": []
                },
                {
                    "RowIndex": 3, "ColIndex": 2, "IsMergeCells": false, "FromRowIndex":3, "ToRowIndex":3, "FromColIndex":2, "ToColIndex":2, "AreaItems": []
                },
                {
                    "RowIndex": 3, "ColIndex": 3, "IsMergeCells": false, "FromRowIndex":3, "ToRowIndex":3, "FromColIndex":3, "ToColIndex":3, "AreaItems": []
                }
            ]
        }
    },

    templateItems: [
        {"Code": "PatDeptDesc", "Desc":"科别", "Type":"textbox", "UnderLine":true, "Unit":"", "DisplayRect":{"left":20,"top":170,"width":80,"height":20}, "UnderLine": true,"Editable": true, "Required": false, "StyleCode": "AreaItemStyle"},
        {"Code": "PatName", "Desc":"患者姓名", "Type":"textbox", "UnderLine":true, "Unit":"", "DisplayRect":{"left":20,"top":170,"width":80,"height":20}, "UnderLine": true,"Editable": true, "Required": false, "StyleCode": "AreaItemStyle"},
        {"Code": "PatGender", "Desc":"性别", "Type":"textbox", "UnderLine":true, "Unit":"", "DisplayRect":{"left":20,"top":170,"width":80,"height":20}, "UnderLine": true,"Editable": true, "Required": false, "StyleCode": "AreaItemStyle"},
        {"Code": "PatAge", "Desc":"年龄", "Type":"textbox", "UnderLine":true, "Unit":"", "DisplayRect":{"left":20,"top":170,"width":80,"height":20}, "UnderLine": true,"Editable": true, "Required": false, "StyleCode": "AreaItemStyle"},
        {"Code": "MedcareNo", "Desc":"病案号", "Type":"textbox", "UnderLine":true, "Unit":"", "DisplayRect":{"left":20,"top":170,"width":80,"height":20}, "UnderLine": true,"Editable": true, "Required": false, "StyleCode": "AreaItemStyle"},
        {"Code": "SurgeonDesc", "Desc":"手术医生", "Type":"textbox", "UnderLine":true, "Unit":"", "DisplayRect":{"left":20,"top":170,"width":80,"height":20}, "UnderLine": true,"Editable": true, "Required": false, "StyleCode": "AreaItemStyle"},
        {"Code": "OperDate", "Desc":"手术日期", "Type":"textbox", "UnderLine":true, "Unit":"", "DisplayRect":{"left":20,"top":170,"width":80,"height":20}, "UnderLine": true,"Editable": true, "Required": false, "StyleCode": "AreaItemStyle"},
        {"Code": "OperationDesc", "Desc":"手术方式", "Type":"textbox", "UnderLine":true, "Unit":"", "DisplayRect":{"left":20,"top":170,"width":80,"height":20}, "UnderLine": true,"Editable": true, "Required": false, "StyleCode": "AreaItemStyle"},
        {"Code": "PatBedCode", "Desc":"床号", "Type":"textbox", "UnderLine":true, "Unit":"", "DisplayRect":{"left":20,"top":170,"width":80,"height":20}, "UnderLine": true,"Editable": true, "Required": false, "StyleCode": "AreaItemStyle"},
        {"Code": "PrevDiagnosisDesc", "Desc":"术前诊断", "Type":"textbox", "UnderLine":true, "Unit":"", "DisplayRect":{"left":20,"top":170,"width":80,"height":20}, "UnderLine": true,"Editable": true, "Required": false, "StyleCode": "AreaItemStyle"},
    ]
}