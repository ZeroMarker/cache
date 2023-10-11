var permissionGroups = [{
    groupName: "手术室护士",
    permissions: [{
        moduleCode: "OperRiskAssessment",
        enableControls: "[data-permission='OperNurse'],[data-permission='All']",
        editStatus: "Arrange^RoomIn^RoomOut",
        precondition: "PatientHandOver:HandOverNurseSign,PatientHandOver:WardNurseSign"
    }, {
        moduleCode: "OperSafetyCheck",
        enableControls: "[data-permission='OperNurse'],[data-permission='All']",
        editStatus: "Arrange^RoomIn^RoomOut",
        precondition: "PatientHandOver:HandOverNurseSign,PatientHandOver:WardNurseSign"
    },{
        moduleCode: "OperCharge",
        enableControls: "[data-permission='OperNurse'],[data-permission='All']",
        editStatus: "Arrange^RoomIn^RoomOut",
        precondition: "PatientHandOver:HandOverNurseSign,PatientHandOver:WardNurseSign"
    },{
        moduleCode: "OperationList",
        enableControls: "[data-permission='All']",
        editStatus: "Arrange^RoomIn^RoomOut",
        precondition: "PatientHandOver:HandOverNurseSign,PatientHandOver:WardNurseSign"
    }]
}, {
    groupName: "手术室护士(局麻)",
    permissions: [{
        moduleCode: "OperRiskAssessment",
        enableControls: "[data-permission='OperNurse'],[data-permission='ANDoc'],[data-permission='All']",
        editStatus: "Arrange^RoomIn^RoomOut",
        precondition: "PatientHandOver:HandOverNurseSign,PatientHandOver:WardNurseSign"
    }, {
        moduleCode: "OperSafetyCheck",
        enableControls: "[data-permission='OperNurse'],[data-permission='ANDoc'],[data-permission='All']",
        editStatus: "Arrange^RoomIn^RoomOut",
        precondition: "PatientHandOver:HandOverNurseSign,PatientHandOver:WardNurseSign"
    },{
        moduleCode: "OperCharge",
        enableControls: "[data-permission='OperNurse'],[data-permission='All']",
        editStatus: "Arrange^RoomIn^RoomOut",
        precondition: "PatientHandOver:HandOverNurseSign,PatientHandOver:WardNurseSign"
    },{
        moduleCode: "OperationList",
        enableControls: "[data-permission='All']",
        editStatus: "Arrange^RoomIn^RoomOut",
        precondition: "PatientHandOver:HandOverNurseSign,PatientHandOver:WardNurseSign"
    }]
},{
    groupName: "手术室护士长",
    permissions: [{
        moduleCode: "OperRiskAssessment",
        enableControls: "[data-permission='OperNurse'],[data-permission='All']",
        editStatus: "Arrange^RoomIn^RoomOut",
        precondition: "PatientHandOver:HandOverNurseSign,PatientHandOver:WardNurseSign"
    }, {
        moduleCode: "OperSafetyCheck",
        enableControls: "[data-permission='OperNurse'],[data-permission='All']",
        editStatus: "Arrange^RoomIn^RoomOut",
        precondition: "PatientHandOver:HandOverNurseSign,PatientHandOver:WardNurseSign"
    }, {
        moduleCode: "OperCount",
        enableControls: "[data-permission='OperNurse'],[data-permission='OperNurseHeader'],[data-permission='All']",
        editStatus: "Arrange^RoomIn^RoomOut",
        precondition: "PatientHandOver:HandOverNurseSign,PatientHandOver:WardNurseSign",
        NeedPermissionAttr:"Y"
    },{
        moduleCode: "OperCharge",
        enableControls: "[data-permission='OperNurse'],[data-permission='OperNurseHeader'],[data-permission='All']",
        editStatus: "Arrange^RoomIn^RoomOut",
        precondition: "PatientHandOver:HandOverNurseSign,PatientHandOver:WardNurseSign"
    },{
        moduleCode: "OperationList",
        enableControls: "[data-permission='All'],[data-permission='OperNurseHeader']",
        editStatus: "Arrange^RoomIn^RoomOut",
        precondition: "PatientHandOver:HandOverNurseSign,PatientHandOver:WardNurseSign"
    }]
}, {
    groupName: "手术室管理员",
    permissions: [{
        moduleCode: "OperRiskAssessment",
        enableControls: "[data-permission='OperNurse'],[data-permission='All']",
        editStatus: "Arrange^RoomIn^RoomOut",
        precondition: "PatientHandOver:HandOverNurseSign,PatientHandOver:WardNurseSign"
    }, {
        moduleCode: "OperSafetyCheck",
        enableControls: "[data-permission='OperNurse'],[data-permission='All']",
        editStatus: "Arrange^RoomIn^RoomOut",
        precondition: "PatientHandOver:HandOverNurseSign,PatientHandOver:WardNurseSign"
    }, {
        moduleCode: "OperCount",
        enableControls: "[data-permission='OperNurse'],[data-permission='OperNurseHeader'],[data-permission='All']",
        editStatus: "Arrange^RoomIn^RoomOut",
        precondition: "PatientHandOver:HandOverNurseSign,PatientHandOver:WardNurseSign",
        NeedPermissionAttr:"Y"
    }]
}, {
    groupName: "麻醉医师",
    permissions: [{
        moduleCode: "OperRiskAssessment",
        enableControls: "[data-permission='OperNurse'],[data-permission='ANDoc'],[data-permission='All']",
        editStatus: "Arrange^RoomIn^RoomOut",
        precondition: "PatientHandOver:HandOverNurseSign,PatientHandOver:WardNurseSign"
    }, {
        moduleCode: "OperSafetyCheck",
        enableControls: "[data-permission='OperNurse'],[data-permission='ANDoc'],[data-permission='All']",
        editStatus: "Arrange^RoomIn^RoomOut",
        precondition: "PatientHandOver:HandOverNurseSign,PatientHandOver:WardNurseSign"
    }, {
        moduleCode: "OperCharge",
        enableControls: "[data-permission='All']",
        editStatus: "Arrange^RoomIn^RoomOut",
        precondition: "PatientHandOver:HandOverNurseSign,PatientHandOver:WardNurseSign"
    },{
        moduleCode: "OperationList",
        enableControls: "[data-permission='All']",
        editStatus: "Arrange^RoomIn^RoomOut",
        precondition: "PatientHandOver:HandOverNurseSign,PatientHandOver:WardNurseSign"
    }]
}, {
    groupName: "麻醉管理员",
    permissions: [{
        moduleCode: "OperRiskAssessment",
        enableControls: "[data-permission='OperNurse'],[data-permission='ANDoc'],[data-permission='All']",
        editStatus: "Arrange^RoomIn^RoomOut",
        precondition: "PatientHandOver:HandOverNurseSign,PatientHandOver:WardNurseSign"
    }, {
        moduleCode: "OperSafetyCheck",
        enableControls: "[data-permission='OperNurse'],[data-permission='ANDoc'],[data-permission='All']",
        editStatus: "Arrange^RoomIn^RoomOut",
        precondition: "PatientHandOver:HandOverNurseSign,PatientHandOver:WardNurseSign"
    }, {
        moduleCode: "OperCharge",
        enableControls: "[data-permission='OperNurse'],[data-permission='OperNurseHeader'],[data-permission='All']",
        editStatus: "Arrange^RoomIn^RoomOut",
        precondition: "PatientHandOver:HandOverNurseSign,PatientHandOver:WardNurseSign"
    },{
        moduleCode: "OperationList",
        enableControls: "[data-permission='All'],[data-permission='OperNurseHeader']",
        editStatus: "Arrange^RoomIn^RoomOut",
        precondition: "PatientHandOver:HandOverNurseSign,PatientHandOver:WardNurseSign"
    }]
}];

var permissionUsers=[{
    userName:"",
    permissions:[{
        moduleCode: "OperCharge",
        enableActions:""
    }]
}];
/**
 * 单位换算关系：1英寸=2.54cm=96px(lodop)
 * A4纸大小 宽：paperWidth=210mm=794px，高：paperHeight=295mm=1115px;
 * 打印整体边距 上：paperTop=20mm=76px，下左右：paperBottom=paperLeft=paperRight=15mm=57px
 * LOGO大小 宽：logoWidth=81mm=306，高：logoHeight=14mm=53px;
 * LOGO医院标志大小 宽：logoFlagWidth=15mm=57px;
 * LOGO位置计算公式 logoLeft=(794-306)/2-57=187px，logoTop=76px;
 * LOGO与表单标题间距：logoTitleMargin=10px;
 * 标题高度：titleHeight=30px;
 * 标题与正文间距：titleContentMargin=10px;
 * 正文可用高度：contentHeight=(paperHeight-paperTop-paperBottom-logoHeight-logoTitleMargin-titleHeight-titleContentMargin)=879px;
 * 正文可用宽度：contentWidth=(paperWidth-paperLeft-paperRight)=680px;
 */
var sheetPrintConfig={
    paper:{
        size:{
            width:794,
            height:1115,
        },
        margin:{
            top:57,
            left:45,
            right:57,
            bottom:57
        },
        name:"A4",
        direction:1
    },
    logo:{
        imgSrc:"../service/dhcanop/css/images/logoxa.png",
        imgWidth:"8.1cm",
        imgHeight:"1.35cm",
        imgTop:"1.4cm",
        imgLeft:"5.7cm",
        size:{
            width:306,
            height:53
        },
        flagSize:{
            width:57,
            height:53
        },
        margin:{
            top:37,
            left:215,
            right:0,
            bottom:10
        }
    },
    title:{
        size:{
            height:30
        },
        margin:{
            bottom:10
        },
        font:{
            name:"黑体",
            size:18
        }
    },
    content:{
        size:{
            width:680,
            height:879
        },
        font:{
            name:"宋体",
            size:11
        }
    }
    // margin:{
    //     left:"1.5cm",
    //     right:"1.5cm",
    //     top:"1.4cm",
    //     bottom:"0.9cm"
    // },
	// title:{
	// 	fontName:"黑体",
	// 	fontSize:"18px"
	// },
	// content:{
	// 	fontName:"宋体",
	// 	fontSize:"14px"
	// }
};

var operCountConfig={
    inventoryMaxCount:40,
    addMoreThanMaxCount:true
};

var operListConfig={
    print:{
        title:"厦门大学附属翔安医院手术排班表",
        paperSize:{
            width:"381mm",
            height:"280mm",
            rect:{
                width:1300,
                height:1058
            }
        },
        direction:1
    },
    sheet:{
        
    }
};

var workstation=[
    {
        id:"116",
        name:"麻醉科",
        url:"dhcan.workstation.an.csp"
    },
    {
        id:"364",
        name:"麻醉科",
        url:"dhcan.workstation.an.csp"
    },
    {
        id:"118",
        name:"手术室",
        url:"dhcan.workstation.opnurse.csp"
    },
    {
        id:"362",
        name:"手术室",
        url:"dhcan.workstation.opnurse.csp"
    },
    {
        id:"215",
        name:"介入治疗中心",
        url:"dhcan.workstation.opnurse.csp"
    }];

var PrintSetting = {
    /**
     * 是否生成电子文档
     */
    GenDigitalDoc: "Y",
    /**
     * 标本管理打印配置
     */
    SpecimenManager: {
        /**
         * 条码纸张名称
         */
        BarCodePaper: "BarCode",
        /**
         * 标本标签纸张名称
         */
        SpecimenTagPaper: "SpecimenTag",
        /**
         * 条码打印机名称
         */
        BarCodePrinter: "Argox CP-2140M PPLB"
    },
    /**
     * 设备登记打印配置
     */
    DeptEquip: {
        /**
         * 条码纸张名称
         */
        BarCodePaper: "BarCode",
        /**
         * 条码打印机名称
         */
        BarCodePrinter: "Argox CP-2140M PPLB"
    },
    /**
     * 通用打印配置
     */
    Common: {
        /**
         * 页面打印纸张名称
         */
        Paper: "A4",
        /**
         * 页面打印机名称
         */
        Printer: "pdfFactory Pro"
    },
    /**
     * 签名生成电子文档打印配置
     */
    AuditSign: {
        /**
         * 页面打印纸张名称
         */
        Paper: "A4",
        /**
         * 页面打印机名称
         */
        Printer: "pdfFactory Pro"
    },
    PrintPaper:{
        Pager:"A4",
        Printer:"手术室打印机1"
    }
};
