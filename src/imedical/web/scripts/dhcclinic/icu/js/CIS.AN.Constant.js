var ANCLS = {
    BLL: {
        AnaestRecord: "CIS.AN.BL.AnaestRecord",
        CodeQueries: "CIS.AN.BL.CodeQueries",
        ConfigQueries: "CIS.AN.BL.ConfigQueries",
        DataConfiguration: "CIS.AN.BL.DataConfiguration",
        DataQueries: "CIS.AN.BL.DataQueries",
        OperApplication: "CIS.AN.BL.OperApplication",
        OperArrange: "CIS.AN.BL.OperArrange",
        Operation: "CIS.AN.BL.Operation",
        OperationList: "CIS.AN.BL.OperationList",
        OperData: "CIS.AN.BL.OperData",
        OperOrder: "CIS.AN.BL.OperOrder",
        OperSchedule: "CIS.AN.BL.OperSchedule",
        OperStatus: "CIS.AN.BL.OperStatus",
        RecordPara: "CIS.AN.BL.RecordPara",
        RecordSheet: "CIS.AN.BL.RecordSheet",
        EquipRecord: "CIS.AN.BL.EquipRecord",
        DeptSchedule: "CIS.AN.BL.DeptSchedule",
        SpecimenManager: "CIS.AN.BL.SpecimenManager",
        Signature: "CIS.AN.BL.Signature",
        Pathology: "CIS.AN.BL.Pathology",
        BloodTransfusion: "CIS.AN.BL.BloodTransfusion",
        ToxicAnestReg: "CIS.AN.BL.ToxicAnestReg",
        SterilityPack: "CIS.AN.BL.SterilityPack",
        DeptEquip: "CIS.AN.BL.DeptEquip",
        SelfPaidConsent: "CIS.AN.BL.SelfPaidConsent",
        ANMobileScanInfo: "CIS.AN.BL.ANMobileScanInfo",
        ChargeRecord: "CIS.AN.BL.ChargeRecord",
        TransMessage: "CIS.AN.BL.TransMessage",
        WorkStat: "CIS.AN.BL.WorkStatistics",
        ArcimRule: "CIS.AN.BL.ArcimRule",
        Preparation: "CIS.AN.BL.AnaestPreparation",
        NarcoticArticle: "CIS.AN.BL.NarcoticArticle",
        Reservation: "CIS.AN.BL.Reservation",
        PrintLog: "CIS.AN.BL.PrintLog",
        AnaData: "CIS.AN.BL.AnaData",
        OperStatistics: "CIS.AN.BL.OperStatistic",
        OperScheduleList: "CIS.AN.BL.OperScheduleList",
        OperShift: "DHCAN.BLL.OperShift",
        PACURecord: "CIS.AN.BL.PACURecord",
        Attendance: "CIS.AN.BL.Attendance",
        AnaArrange: "CIS.AN.BL.AnaArrange",
        DataGrid: "CIS.AN.BL.DataGrid",
        SheetSettings:"CIS.AN.BL.SheetSettings",
        DaySurgery: "CIS.AN.BL.DaySurgery",  //202002+dyl
        Workstation:"CIS.AN.BL.Workstation"
    },
    Code: {
        ASAClass: "CT.AN.ASAClass",
        AnaType: "CT.AN.AnaType",
        AnaMethod: "CT.AN.AnaMethod",
        BladeType: "CT.AN.BladeType",
        BodySite: "CT.AN.BodySite",
        OperClass: "CT.AN.OperClass",
        OperPosition: "CT.AN.OperPosition",
        Operation: "CT.AN.Operation",
        DataModule: "CT.AN.DataModule",
        OperAction: "CT.AN.OperAction",
        DataCategory: "CT.AN.DataCategory",
        DataItem: "CT.AN.DataItem",
        DataCateItem: "CT.AN.DataCateItem",
        DrugItem: "CT.AN.DrugItem",
        DrugGroup: "CT.AN.DrugGroup",
        DrugGroupItem: "CT.AN.DrugGroupItem",
        EventItem: "CT.AN.EventItem",
        EventOptions: "CT.AN.EventOptions",
        VitalSign: "CT.AN.VitalSign",
        AnaCatheter: "CT.AN.AnaCatheter",
        Catheter: "CT.AN.Catheter",
        CatheterDepth: "CT.AN.CatheterDepth",
        CatheterDirection: "CT.AN.CatheterDirection",
        CatheterPath: "CT.AN.CatheterPath",
        CatheterTool: "CT.AN.CatheterTool",
        CatheterType: "CT.AN.CatheterType",
        PositionMethod: "CT.AN.PositionMethod",
        PunctureSpace: "CT.AN.PunctureSpace",
        Reason: "CT.AN.Reason",
        Specimen: "CT.AN.Specimen",
        EquipMFR: "CT.AN.EquipMFR",
        EquipType: "CT.AN.EquipType",
        EquipModel: "CT.AN.EquipModel",
        DesityUom: "CT.AN.DesityUom",
        SpeedUom: "CT.AN.SpeedUom",
        Uom: "CT.AN.Uom",
        UomConversion: "CT.AN.UomConversion",
        Holiday: "CT.AN.Holiday",
        SurgicalKits: "CT.AN.SurgicalKit",
        SurMaterials: "CT.AN.SurgicalMaterial",
        KitMaterials: "CT.AN.SurgicalKitMat",
        MedSupplies: "CT.AN.MedSupplies",
        Legend: "CT.AN.Legend",
        LegendData: "CT.AN.LegendData",
        OperStatus: "CT.AN.OperStatus",
        ModDataOptions: "CT.AN.ModDataOptions",
        DataOptions: "CT.AN.DataOptions",
        Menu: "CT.AN.Menu",
        MenuItem: "CT.AN.MenuItem",
        PrintTemplate: "CT.AN.PrintTemplate",
        OperRiskControl: "CT.AN.OperRiskControl",
        OperLinkBodySite:"CT.AN.OperLinkBodySite"
    },
    Config: {
        ActionPermission: "CF.AN.ActionPermission",
        CPTypeOperClass: "CF.AN.CPTypeOperClass",
        DataConfig: "CF.AN.DataConfig",
        DefOperDept: "CF.AN.DefOperDept",
        DeptEquip: "CF.AN.DeptEquip",
        DeptOperation: "CF.AN.DeptOperation",
        EquipCollection: "CF.AN.EquipCollection",
        Location: "CF.AN.Location",
        ModPermission: "CF.AN.ModPermission",
        ModuleTemplate: "CF.AN.ModuleTemplate",
        ModuleTmplItem: "CF.AN.ModuleTmplItem",
        SurgeonOperation: "CF.AN.SurgeonOperation",
        TestCode: "CF.AN.TestCode",
        SelfPaidDrug: "CF.AN.SelfPaidDrug",
        SelfPaidMaterial: "CF.AN.SelfPaidMaterial",
        UserDefDataItem: "CF.AN.UserDefDataItem",
        ChargeItem: "CF.AN.ChargeItem",
        ChargeItemLink: "CF.AN.ChargeItemLink",
        ChargeSet: "CF.AN.ChargeSet",
        ChargeSetItem: "CF.AN.ChargeSetItem",
        UserPreferedData: "CF.AN.UserPreferedData",
        UserPreferedDrug: "CF.AN.UserPreferedDrug",
        UserPreferedEventDetail: "CF.AN.UserPreferedEventDetail",
        PersonalSetting: "CF.AN.PersonalSetting",
        Screen: "CF.AN.Screen",
        ArcimRule: "CF.AN.ArcimRule",
        DrugArcim: "CF.AN.DrugArcim",
        EventArcim: "CF.AN.EventArcim",
        AnaMethodArcim: "CF.AN.AnaMethodArcim",
        CatheterArcim: "CF.AN.CatheterArcim",
        NarcoticArticle: "CF.AN.NarcoticArticle",
        MenuPermission: "CF.AN.MenuPermission",
        DataGrid: "CF.AN.DataGrid",
        DataColumn: "CF.AN.DataColumn",
        OperFloor: "CF.AN.OperFloor",
        SheetPermission:"CF.AN.SheetPermission",
        SheetElement:"CF.AN.SheetElement",
        SurgeonGroup: "CF.AN.SurgeonGroup",
        TextTemplate:"CF.AN.TextTemplate",
        TextTemplateItem:"CF.AN.TextTemplateItem",
        Hospital:"CF.AN.Hospital",
        Department:"CF.AN.Department",
        SSGroup:"CF.AN.SSGroup"
    },
    Model: {
        AnaData: "CIS.AN.AnaData",
        Anaesthesia: "CIS.AN.Anaesthesia",
        BloodTransCmpt: "CIS.AN.BloodTransCmpt",
        BloodTransfusion: "CIS.AN.BloodTransfusion",
        BloodTransRecord: "CIS.AN.BloodTransRecord",
        BloodTransShift: "CIS.AN.BloodTransShift",
        CollectedData: "CIS.AN.CollectedData",
        DrugData: "CIS.AN.DrugData",
        EquipRecord: "CIS.AN.EquipRecord",
        EquipService: "CIS.AN.EquipService",
        EventData: "CIS.AN.EventData",
        OperData: "CIS.AN.OperData",
        OperList: "CIS.AN.OperList",
        OperSchedule: "CIS.AN.OperSchedule",
        OperShift: "CIS.AN.OperShift",
        PlanOperList: "CIS.AN.PlanOperList",
        RecordFiles: "CIS.AN.RecordFiles",
        RecordSheet: "CIS.AN.RecordSheet",
        RecParaItem: "CIS.AN.ParaItem",
        Signature: "CIS.AN.Signature",
        SpecimenReg: "CIS.AN.SpecimenReg",
        SpecimenShift: "CIS.AN.SpecimenShift",
        SterilityPack: "CIS.AN.SterilityPack",
        SterilityItem: "CIS.AN.SterilityItem",
        SurInventory: "CIS.AN.SurgicalInventory",
        SurSupplies: "CIS.AN.SurSupplies",
        TimeLine: "CIS.AN.TimeLine",
        ToxicAnaestReg: "CIS.AN.ToxicAnestReg",
        OperRoomNurse: "CIS.AN.OperRoomNurse",
        OperDrugData: "CIS.AN.OperDrugData",
        SkinCondition: "CIS.AN.SkinCondition",
        ToxicAnestReg: "CIS.AN.ToxicAnestReg",
        ToxicAnestClaim: "CIS.AN.ToxicAnestClaim",
        ParaItemAttr: "CIS.AN.ParaItemAttr",
        SelfPaidDrugData: "CIS.AN.SelfPaidDrugData",
        SelfPaidMaterialData: "CIS.AN.SelfPaidMaterialData",
        PACUTransaction: "CIS.AN.PACUTransaction",
        AnaestEvaluation: "CIS.AN.AnaestEvaluation",
        AnaestSchedule: "CIS.AN.AnaestSchedule",
        ChargeRecord: "CIS.AN.ChargeRecord",
        ChargeRecordDetail: "CIS.AN.ChargeDetail",
        TransferMessage: "CIS.AN.TransferMessage",
        AnaestPreparation: "CIS.AN.AnaestPreparation",
        Reservation: "CIS.AN.Reservation",
        PrintLog: "CIS.AN.PrintLog",
        Specimen: "CIS.AN.Specimen",
        PathologyRecord: "CIS.AN.PathologyRecord",
        Attendance: "CIS.AN.Attendance",
        AnaestCatheter: 'CIS.AN.AnaestCatheter',
        MaterialPack: "CIS.AN.MaterialPack" //20200213+dyl
    },
    CA:{
        SignatureService:"CIS.AN.CA.SignatureService"
    }
};

var CLCLS = {
    BLL: {
        Admission: "CIS.AN.BL.Admission",
        DataService: "CIS.AN.COM.DataService",
        Test: "CIS.AN.COM.Test",
        OEOrder: "CIS.AN.BL.OEOrder",
        StockManager: "CIS.AN.COM.StockManager",
        ConfigQueries: "CIS.AN.COM.ConfigQueries",
        SecureUser: "CIS.AN.COM.SecureUser"
    },
    Code: {
        Manufacturer: "DHCCL.Code.Manufacturer",
        Vendor: "DHCCL.Code.Vendor",
        StockCat: "DHCCL.Code.StockCat"
    },
    Config: {
        Location: "DHCCL.Config.Location",
        Uom: "DHCCL.Config.Uom",
        StockItem: "DHCCL.Config.StockItem",
        StockLocation: "DHCCL.Config.StockLocation",
        StockSet: "DHCCL.Config.StockSet",
        StockSetItem: "DHCCL.Config.StockSetItem",
        SecureUser: "DHCCL.Config.SecureUser"
    },
    Model: {
        StockTransfer: "DHCCL.Model.StockTransfer",
        StockConsume: "DHCCL.Model.StockConsume",
        StockMonth: "DHCCL.Model.StockMonth",
        StockMonthItem: "DHCCL.Model.StockMonthItem"
    }
};

var ANCSP = {
    DataQuery: "CIS.AN.DataQuery.csp",
    DataQueries: "CIS.AN.DataQueries.csp",
    DataService: "CIS.AN.DataService.csp",
    DataListService: "CIS.AN.DataListService.csp",
    MethodService: "CIS.AN.MethodService.csp"
};

var Controls = {
    ValidateBox: "hisui-validatebox",
    ComboBox: "hisui-combobox",
    DateBox: "hisui-datebox",
    DateTimeBox: "hisui-datetimebox",
    SearchBox: "hisui-searchbox",
    Combo: "hisui-combo",
    CheckBox: "hisui-checkbox",
    TimeSpinner: "hisui-timespinner",
    SwitchBox: "hisui-swithbox",
    FileBox: "hisui-filebox",
    LinkButton: "hisui-linkbutton",
    NumberBox: "hisui-numberbox",
    Radio: "hisui-radio",
    TriggerBox:"hisui-triggerbox"
};

var InputType = {
    Text: "text",
    CheckBox: "checkbox"
};

var OperStatus = {
    Application: "Application",
    Audit: "Audit",
    Arrange: "Arrange",
    RoomIn: "RoomIn",
    RoomOut: "RoomOut",
    PACUIn: "PACUIn",
    Finish: "Finish",
    Decline: "Decline",
    Cancel: "Cancel",
    Revoke: "Revoke",
    AreaIn: "AreaIn",
    AreaOut: "AreaOut"
};



/**
 * 分割字符串
 */
var splitchar = {
    /**
     * ASCII 0
     */
    zero: String.fromCharCode(0),
    /**
     * ASCII 1
     */
    one: String.fromCharCode(1),
    /**
     * ASCII 2
     */
    two: String.fromCharCode(2),
    /**
     * ASCII 3
     */
    three: String.fromCharCode(3),
    /**
     * ASCII 4
     */
    four: String.fromCharCode(4),
    /**
     * ASCII 5
     */
    five: String.fromCharCode(5),
    /**
     * 逗号
     */
    comma: ",",
    /**
     * 分号
     */
    semicolon: ";",
    /**
     * 井号
     */
    well: "#",
    /**
     * 美元
     */
    dollar: "$",
    /**
     * 箭头
     */
    arrow: "^",
    /**
     * 感叹号
     */
    exclamation: "!",
    /**
     * 空字符串
     */
    empty: "",

    /**
     * 斜杆
     */
    emptyContent: "/"
};

var MAXDATE = new Date('12/30/9999');

/**
 * 常用数组，是否、有无
 */
var CommonArray = {
    /**
     * 是否数组
     */
    WhetherOrNot: [{
        value: "",
        text: ""
    }, {
        value: "Y",
        text: "是",
    }, {
        value: "N",
        text: "否"
    }],

    /**
     * 有无数组
     */
    HaveOrNot: [{
        value: "",
        text: ""
    }, {
        value: "Y",
        text: "有"
    }, {
        value: "N",
        text: "无"
    }],

    TrueOrFalse: [{
        value: "true",
        text: "true"
    }, {
        value: "false",
        text: "false"
    }],

    UnitTypes:[{
        value:"",
        text:""
    },{
        value:"N",
        text:"普通单位",
    },{
        value:"C",
        text:"浓度单位"
    },{
        value:"S",
        text:"速度单位"
    },{
        value:"D",
        text:'剂量单位'
    },{
        value:"T",
        text:"时间单位"
    }],

    SourceTypes:[{
        value:"B",
        text:"择期"
    },{
        value:"E",
        text:"急诊"
    }],

    SeqTypes:[{
        value:"N",
        text:"正常台"
    },{
        value:"C",
        text:"接台"
    }],

    BloodTypes:[{
        text:"未知",
        value:"N"
    },{
        text:"A型",
        value:"A"
    },{
        text:"B型",
        value:"B"
    },{
        text:"AB型",
        value:"AB"
    },{
        text:"O型",
        value:"O"
    }],

    RHDTypes:[{
        text:"未知",
        value:"N"
    },{
        text:"阳性",
        value:"+"
    },{
        text:"阴性",
        value:"-"
    }],

    InfectionTypes:[{
        text:"未知",
        value:"N"
    },{
        text:"阴性",
        value:"-"
    },{
        text:"阳性",
        value:"+"
    }]
}

var SourceTypeColors={
    Emergency:"#ff9999",
    Book:"#ffcc66",
    DaySurgery:"#cccc66"
}