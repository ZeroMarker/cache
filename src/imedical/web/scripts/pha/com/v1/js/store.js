/**
 * 名称:	 药房公共-数据集集合
 * 编写人:	 yunhaibao
 * 编写日期: 2019-03-12
 */

var PHA_STORE = {
    Url: $URL + '?ResultSetType=Array&',
    RowUrl: $URL + '?ResultSetType=Array&',
    // 院区
    CTHospital: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Org&QueryName=CTHospital'
        };
    },
    // 单位
    CTUOM: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Drug&QueryName=CTUOM&HospId=' + PHA_COM.Session.HOSPID
        };
    },
    // 剂型
    PHCForm: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Drug&QueryName=PHCForm'
        };
    },
    // 疗程
    PHCDuration: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Drug&QueryName=PHCDuration'
        };
    },
    // 频次
    PHCFreq: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Drug&QueryName=PHCFreq'
        };
    },
    // 管制分类
    PHCPoison: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Drug&QueryName=PHCPoison'
        };
    },
    // 用户权限科室
    UserLoc: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Org&QueryName=UserLoc&HospId=' + PHA_COM.Session.HOSPID
        };
    },
    /**
     * 药房
     * @param {String} type OP-门诊,IP-住院,空-所有
     */
    Pharmacy: function (type) {
        type = type || '';
        return {
            url: this.Url + 'ClassName=PHA.STORE.Org&QueryName=Pharmacy&Type=' + type + '&HospId=' + PHA_COM.Session.HOSPID
        };
    },
    // 医生科室
    DocLoc: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Org&QueryName=CTLoc&Type=E,EM&HospId=' + PHA_COM.Session.HOSPID
        };
    },
    // 所有科室
    CTLoc: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Org&QueryName=CTLoc&HospId=' + PHA_COM.Session.HOSPID
        };
    },
    // 急诊留观
    EMLGLoc: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Org&QueryName=EMLGLoc&HospId=' + PHA_COM.Session.HOSPID
        };
    },
    // 病区 CTLOC的ID
    WardLoc: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Org&QueryName=WardLoc&HospId=' + session['LOGON.HOSPID']
        };
    },
    // 医生
    Doctor: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Org&QueryName=Doctor&HospId=' + PHA_COM.Session.HOSPID
        };
    },
    // 药师
    Pharmacist: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Org&QueryName=Pharmacist&HospId=' + PHA_COM.Session.HOSPID
        };
    },
    // 用户
    SSUser: function (locId, onlyDef) {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Org&QueryName=SSUser&HospId=' + PHA_COM.Session.HOSPID
        };
    },
    // 安全组
    SSGroup: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Org&QueryName=SSGroup&HospId=' + PHA_COM.Session.HOSPID
        };
    },
    // 费别
    PACAdmReason: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Other&QueryName=PACAdmReason&HospId=' + PHA_COM.Session.HOSPID
        };
    },
    // 费用大类
    ARCBillGrp: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Drug&QueryName=ARCBillGrp&HospId=' + PHA_COM.Session.HOSPID
        };
    },
    // 费用子类
    ARCBillSub: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Drug&QueryName=ARCBillSub&HospId=' + PHA_COM.Session.HOSPID
        };
    },
    // 医嘱大类
    OECOrderCategory: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Drug&QueryName=OECOrderCategory&HospId=' + PHA_COM.Session.HOSPID
        };
    },
    // 医嘱子类
    ARCItemCat: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Drug&QueryName=ARCItemCat&HospId=' + PHA_COM.Session.HOSPID
        };
    },
    // 高危级别
    PHCDFHighRisk: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Drug&QueryName=PHCDFHighRisk'
        };
    },
    // ^DHCSTOFFICODE,批准文号前缀等(Gpp,Gp)
    // Gpp:处方药分类,Gp:国药准字前缀
    DHCSTOFFICODE: function (type) {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Drug&QueryName=DHCSTOFFICODE&Type=' + type
        };
    },
    // 医嘱优先级
    OECPriority: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Drug&QueryName=OECPriority'
        };
    },
    // 用法
    PHCInstruc: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Drug&QueryName=PHCInstruc'
        };
    },
    // 草药备注
    PHCDFCHPhSpecInstr: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Drug&QueryName=PHCDFCHPhSpecInstr'
        };
    },
    // 类组
    DHCStkCatGroup: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Drug&QueryName=DHCStkCatGroup&HospId=' + PHA_COM.Session.HOSPID
        };
    },
    // 库存分类
    INCStkCat: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Drug&QueryName=INCStkCat&HospId=' + PHA_COM.Session.HOSPID
        };
    },
    // 定价类型
    DHCMarkType: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Drug&QueryName=DHCMarkType&HospId=' + PHA_COM.Session.HOSPID
        };
    },
    // 质量层次
    DHCItmQualityLevel: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Drug&QueryName=DHCItmQualityLevel&HospId=' + PHA_COM.Session.HOSPID
        };
    },
    // 不可退药原因
    DHCStkRefuseRetReason: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Drug&QueryName=DHCStkRefuseRetReason&HospId=' + PHA_COM.Session.HOSPID
        };
    },
    // 不可用原因
    DHCItmNotUseReason: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Drug&QueryName=DHCItmNotUseReason&HospId=' + PHA_COM.Session.HOSPID
        };
    },
    // 新病案首页子类
    DHCTarMCCateNew: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Drug&QueryName=DHCTarMCCateNew&HospId=' + PHA_COM.Session.HOSPID
        };
    },
    // 病案首页子类
    DHCTarMCCate: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Drug&QueryName=DHCTarMRCate&HospId=' + PHA_COM.Session.HOSPID
        };
    },
    // 核算子类
    DHCTarEMCCate: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Drug&QueryName=DHCTarEMCCate&HospId=' + PHA_COM.Session.HOSPID
        };
    },
    // 门诊子分类
    DHCTarOutpatCate: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Drug&QueryName=DHCTarOutpatCate&HospId=' + PHA_COM.Session.HOSPID
        };
    },
    // 住院子分类
    DHCTarInpatCate: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Drug&QueryName=DHCTarInpatCate&HospId=' + PHA_COM.Session.HOSPID
        };
    },
    // 会计子分类
    DHCTarAcctCate: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Drug&QueryName=DHCTarAcctCate&HospId=' + PHA_COM.Session.HOSPID
        };
    },
    // 收费子类
    DHCTarSubCate: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Drug&QueryName=DHCTarSubCate&HospId=' + PHA_COM.Session.HOSPID
        };
    },
    // 配送企业,配送商
    DHCCarrier: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Unit&QueryName=DHCCarrier&HospId=' + PHA_COM.Session.HOSPID
        };
    },
    // 经营企业,供应商
    APCVendor: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Unit&QueryName=APCVendor&HospId=' + PHA_COM.Session.HOSPID
        };
    },
    // 生产企业,厂商
    PHManufacturer: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Unit&QueryName=PHManufacturer&HospId=' + PHA_COM.Session.HOSPID
        };
    },
    // 招标名称
    DHCPublicBiddingList: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Drug&QueryName=DHCPublicBiddingList&HospId=' + PHA_COM.Session.HOSPID
        };
    },
    // 招标级别
    DHCItmPBLevel: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Drug&QueryName=DHCItmPBLevel&HospId=' + PHA_COM.Session.HOSPID
        };
    },
    // 账簿分类
    DHCSTBookCat: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Drug&QueryName=DHCSTBookCat&HospId=' + PHA_COM.Session.HOSPID
        };
    },
    // 药品易混淆类型
    DHCINCEasyConDescType: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Drug&QueryName=DHCINCEasyConDescType'
        };
    },
    // 卡类型
    DHCCardTypeDef: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Org&QueryName=DHCCardTypeDef'
        };
    },
    // 医嘱项
    ArcItmMast: function (active) {
        return {
            queryParams: {
                ClassName: 'PHA.STORE.Drug',
                QueryName: 'ArcItmMast',
                Active: active || '',
                HospId: PHA_COM.Session.HOSPID
            },
            panelWidth: 400,
            idField: 'arcimId',
            textField: 'arcimDesc',
            columns: [
                [
                    {
                        field: 'arcimCode',
                        title: '代码',
                        width: 100
                    },
                    {
                        field: 'arcimDesc',
                        title: '名称',
                        width: 250
                    },
                    {
                        field: 'arcimId',
                        title: 'arcimId',
                        width: 50,
                        hidden: true
                    }
                ]
            ]
        };
    },
    // 品种通用名
    DHCPHChemical: function () {
        return {
            queryParams: {
                ClassName: 'PHA.STORE.Drug',
                QueryName: 'DHCPHChemical'
            },
            panelWidth: 450,
            idField: 'chemId',
            textField: 'chemDesc',
            columns: [
                [
                    {
                        field: 'chemCode',
                        title: '代码',
                        width: 150
                    },
                    {
                        field: 'chemDesc',
                        title: '名称',
                        width: 275
                    },
                    {
                        field: 'chemId',
                        title: 'chemId',
                        width: 50,
                        hidden: true
                    }
                ]
            ]
        };
    },
    // 处方通用名
    PHCGeneric: function () {
        return {
            queryParams: {
                ClassName: 'PHA.STORE.Drug',
                QueryName: 'PHCGeneric'
            },
            panelWidth: 460,
            idField: 'geneId',
            textField: 'geneName',
            columns: [
                [
                    {
                        field: 'geneCode',
                        title: '代码',
                        width: 150
                    },
                    {
                        field: 'geneName',
                        title: '名称',
                        width: 275
                    },
                    {
                        field: 'geneId',
                        title: 'geneId',
                        width: 50,
                        hidden: true
                    }
                ]
            ]
        };
    },
    // 库存项
    INCItm: function (active) {
        return {
            queryParams: {
                ClassName: 'PHA.STORE.Drug',
                QueryName: 'INCItm',
                Active: active || ''
            },
            panelWidth: 400,
            idField: 'inciId',
            textField: 'inciDesc',
            columns: [
                [
                    {
                        field: 'inciCode',
                        title: '代码',
                        width: 100
                    },
                    {
                        field: 'inciDesc',
                        title: '名称',
                        width: 250
                    },
                    {
                        field: 'inciId',
                        title: 'inciId',
                        width: 50,
                        hidden: true
                    }
                ]
            ]
        };
    },
    // WHONET码
    WHONET: function () {
        return {
            queryParams: {
                ClassName: 'PHA.STORE.Drug',
                QueryName: 'WHONET'
            },
            panelWidth: 460,
            idField: 'antCode',
            textField: 'antCode',
            columns: [
                [
                    {
                        field: 'antCode',
                        title: '代码',
                        width: 100
                    },
                    {
                        field: 'antName',
                        title: '名称',
                        width: 200
                    },
                    {
                        field: 'antEName',
                        title: '英文名称',
                        width: 250
                    }
                ]
            ]
        };
    },
    // 药品属性通用字典 - 没有特殊情况请使用ascode
    ComDictionary: function (DicType) {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Drug&QueryName=StkComDictionary&ScdType=' + DicType
        };
    },
    // 药品属性通用字典,以代码为ID
    ComDictionaryAsCode: function (DicType) {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Drug&QueryName=StkComDictionaryAsCode&ScdType=' + DicType
        };
    },
    // 采购计划类型
    PurPlanType: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Drug&QueryName=PurPlanType'
        };
    },
    // 产地
    DHCSTOrigin: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Unit&QueryName=DHCSTOrigin&HospId=' + PHA_COM.Session.HOSPID
        };
    },
    // WHODDD单位
    WHODDDUOM: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Drug&QueryName=WHODDDUOM'
        };
    }
};
