var ANCLS = {
    BLL: {
        AnaestRecord: "DHCAN.BLL.AnaestRecord",
        CodeQueries: "DHCAN.BLL.CodeQueries",
        ConfigQueries: "DHCAN.BLL.ConfigQueries",
        DataConfiguration: "DHCAN.BLL.DataConfiguration",
        DataQueries: "DHCAN.BLL.DataQueries",
        OperApplication: "DHCAN.BLL.OperApplication",
        OperArrange: "DHCAN.BLL.OperArrange",
        Operation: "DHCAN.BLL.Operation",
        OperationList: "DHCAN.BLL.OperationList",
        OperData: "DHCAN.BLL.OperData",
        OperOrder: "DHCAN.BLL.OperOrder",
        OperSchedule: "DHCAN.BLL.OperSchedule",
        OperStatus: "DHCAN.BLL.OperStatus",
        RecordPara: "DHCAN.BLL.RecordPara",
        RecordSheet: "DHCAN.BLL.RecordSheet",
        EquipRecord: "DHCAN.BLL.EquipRecord",
        DeptSchedule: "DHCAN.BLL.DeptSchedule",
        SpecimenManager: "DHCAN.BLL.SpecimenManager"
    },
    Code: {
        ASAClass: "DHCAN.Code.ASAClass",
        AnaType: "DHCAN.Code.AnaType",
        AnaMethod: "DHCAN.Code.AnaMethod",
        BladeType: "DHCAN.Code.BladeType",
        BodySite: "DHCAN.Code.BodySite",
        OperClass: "DHCAN.Code.OperClass",
        OperPosition: "DHCAN.Code.OperPosition",
        Operation: "DHCAN.Code.Operation",
        DataModule: "DHCAN.Code.DataModule",
        OperAction: "DHCAN.Code.OperAction",
        DataCategory: "DHCAN.Code.DataCategory",
        DataItem: "DHCAN.Code.DataItem",
        DataCateItem: "DHCAN.Code.DataCateItem",
        DrugItem: "DHCAN.Code.DrugItem",
        EventItem: "DHCAN.Code.EventItem",
        EventOptions: "DHCAN.Code.EventOptions",
        VitalSign: "DHCAN.Code.VitalSign",
        AnaCatheter: "DHCAN.Code.AnaCatheter",
        Catheter: "DHCAN.Code.Catheter",
        CatheterDepth: "DHCAN.Code.CatheterDepth",
        CatheterDirection: "DHCAN.Code.CatheterDirection",
        CatheterPath: "DHCAN.Code.CatheterPath",
        CatheterTool: "DHCAN.Code.CatheterTool",
        CatheterType: "DHCAN.Code.CatheterType",
        PositionMethod: "DHCAN.Code.PositionMethod",
        PunctureSpace: "DHCAN.Code.PunctureSpace",
        Reason: "DHCAN.Code.Reason",
        Specimen: "DHCAN.Code.Specimen",
        EquipMFR: "DHCAN.Code.EquipMFR",
        EquipType: "DHCAN.Code.EquipType",
        EquipModel: "DHCAN.Code.EquipModel",
        DesityUom: "DHCAN.Code.DesityUom",
        SpeedUom: "DHCAN.Code.SpeedUom",
        Uom: "DHCAN.Code.Uom",
        UomConversion: "DHCAN.Code.UomConversion",
        Holiday: "DHCAN.Code.Holiday",
        SurgicalKits: "DHCAN.Code.SurgicalKits",
        SurMaterials: "DHCAN.Code.SurMaterials",
        KitMaterials: "DHCAN.Code.KitMaterials",
        MedSupplies: "DHCAN.Code.MedSupplies",
        Legend: "DHCAN.Code.Legend",
        LegendData: "DHCAN.Code.LegendData",
        OperStatus: "DHCAN.Code.OperStatus",
        OperFloor: "DHCAN.Code.OperFloor",
        ModDataOptions: "DHCAN.Code.ModDataOptions",
        DataOptions: "DHCAN.Code.DataOptions"
    },
    Config: {
        ActionPermission: "DHCAN.Config.ActionPermission",
        CPTypeOperClass: "DHCAN.Config.CPTypeOperClass",
        DataConfig: "DHCAN.Config.DataConfig",
        DefOperDept: "DHCAN.Config.DefOperDept",
        DeptEquip: "DHCAN.Config.DeptEquip",
        DeptOperation: "DHCAN.Config.DeptOperation",
        EquipCollection: "DHCAN.Config.EquipCollection",
        Location: "DHCAN.Config.Location",
        ModPermission: "DHCAN.Config.ModPermission",
        ModuleTemplate: "DHCAN.Config.ModuleTemplate",
        ModuleTmplItem: "DHCAN.Config.ModuleTmplItem",
        SurgeonOperation: "DHCAN.Config.SurgeonOperation",
        TestCode: "DHCAN.Config.TestCode"
    },
    Model: {
        AnaData: "DHCAN.Model.AnaData",
        Anaesthesia: "DHCAN.Model.Anaesthesia",
        BloodTransCmpt: "DHCAN.Model.BloodTransCmpt",
        BloodTransfusion: "DHCAN.Model.BloodTransfusion",
        BloodTransRecord: "DHCAN.Model.BloodTransRecord",
        BloodTransShift: "DHCAN.Model.BloodTransShift",
        CollectedData: "DHCAN.Model.CollectedData",
        DrugData: "DHCAN.Model.DrugData",
        EquipRecord: "DHCAN.Model.EquipRecord",
        EquipService: "DHCAN.Model.EquipService",
        EventData: "DHCAN.Model.EventData",
        OperData: "DHCAN.Model.OperData",
        OperList: "DHCAN.Model.OperList",
        OperSchedule: "DHCAN.Model.OperSchedule",
        OperShift: "DHCAN.Model.OperShift",
        PlanOperList: "DHCAN.Model.PlanOperList",
        RecordFiles: "DHCAN.Model.RecordFiles",
        RecordSheet: "DHCAN.Model.RecordSheet",
        RecParaItem: "DHCAN.Model.RecParaItem",
        Signature: "DHCAN.Model.Signature",
        SpecimenReg: "DHCAN.Model.SpecimenReg",
        SpecimenShift: "DHCAN.Model.SpecimenShift",
        SterilityPack: "DHCAN.Model.SterilityPack",
        SurInventory: "DHCAN.Model.SurInventory",
        SurSupplies: "DHCAN.Model.SurSupplies",
        TimeLine: "DHCAN.Model.TimeLine",
        ToxicAnaestReg: "DHCAN.Model.ToxicAnestReg",
        OperRoomNurse: "DHCAN.Model.OperRoomNurse",
        OperDrugData: "DHCAN.Model.OperDrugData",
        SkinCondition: "DHCAN.Model.SkinCondition"
    }
};

var CLCLS = {
    BLL: {
        Admission: "DHCCL.BLL.Admission",
        DataService: "DHCCL.BLL.DataService",
        Test: "DHCCL.BLL.Test",
        OEOrder: "DHCCL.BLL.OEOrder",
        StockManager: "DHCCL.BLL.StockManager"
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
        StockLocation: "DHCCL.Config.StockLocation"
    },
    Model: {
        StockTransfer: "DHCCL.Model.StockTransfer",
        StockConsume: "DHCCL.Model.StockConsume",
        StockMonth: "DHCCL.Model.StockMonth",
        StockMonthItem: "DHCCL.Model.StockMonthItem"
    }
};

var ANCSP = {
    DataQuery: "dhccl.dataquery.csp",
    DataQueries: "dhccl.dataqueries.csp",
    DataService: "dhccl.dataservice.csp",
    DataListService: "dhccl.datalistservice.csp",
    MethodService: "dhccl.methodservice.csp"
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
    Radio: "hisui-radio"
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

var PrintSetting = {
    SpecimenManager: {
        BarCodePaper: "BarCode",
        SpecimenTagPaper: "SpecimenTag",
        Printer: ""
    },
    DeptEquip: {
        BarCodePaper: "BarCode",
        Printer: ""
    }
};

/**
 * 分割(拼接)字符串对象
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
     * 上箭头
     */
    arrow: "^",
    /**
     * 感叹号
     */
    exclamation: "!",
    /**
     * 空字符串
     */
    empty: ""
};