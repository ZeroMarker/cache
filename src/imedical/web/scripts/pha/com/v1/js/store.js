/**
 * 名称:	 药房公共-数据集集合
 * 编写人:	 yunhaibao
 * 编写日期: 2019-03-12
 * Org-科室用户类数据集;Drug-药品信息类的数据集;Unit供应商,厂家等单位;Other-其它，比如非其它组属性;
 * scripts/pha/com/v1/js/store.js
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
            url: this.Url + 'ClassName=PHA.STORE.Org&QueryName=CTLoc&TypeStr=E,EM,O,OP,IP&HospId=' + PHA_COM.Session.HOSPID
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
    WardLoc: function (cspName, SRLSelectCode) {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Org&QueryName=WardLoc&HospId=' + PHA_COM.Session.HOSPID + '&cspName=' + cspName + '&SRLSelectCode=' + SRLSelectCode
        };
    },
    // 接收科室对应的病区 CTLOC的ID  by zhaoxinlong 2022.04.24
    WardLocByRecLoc: function (cspName, SRLSelectCode) {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Org&QueryName=WardLocByRecLoc&HospId=' + PHA_COM.Session.HOSPID + '&cspName=' + cspName + '&SRLSelectCode=' + SRLSelectCode
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
        locId = locId || '';
        return {
            url: this.Url + 'ClassName=PHA.STORE.Org&QueryName=SSUser&HospId=' + PHA_COM.Session.HOSPID + '&LocId=' + locId
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
            url: this.Url + 'ClassName=PHA.STORE.Drug&QueryName=PHCDFCHPhSpecInstr&HospId=' + PHA_COM.Session.HOSPID
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
                        title: '医嘱项ID',
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
                        title: '品种通用名ID',
                        width: 50,
                        hidden: true
                    }
                ]
            ]
        };
    },
    // 处方通用名
    PHCGeneric: function (active) {
        return {
            queryParams: {
                ClassName: 'PHA.STORE.Drug',
                QueryName: 'PHCGeneric',
                Active: active || ''
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
                        title: '处方通用名ID',
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
                Active: active || '',
                Hosp: PHA_COM.Session.HOSPID
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
                        title: '库存项ID',
                        width: 50,
                        hidden: true
                    }
                ]
            ]
        };
    },
    // 库存项(临购药品)
    INCItmForTmp: function (active) {
        return {
            queryParams: {
                ClassName: 'PHA.STORE.Drug',
                QueryName: 'INCItmForTmp',
                Active: active || '',
                Hosp: PHA_COM.Session.HOSPID
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
                        title: '库存项ID',
                        width: 50,
                        hidden: true
                    }
                ]
            ]
        };
    },
    // 科室药品库存项(判断类组权限)
    INCItmForLoc: function (active, Loc, User, Scg) {
        return {
            queryParams: {
                ClassName: 'PHA.STORE.Drug',
                QueryName: 'INCItmForLoc',
                Loc: Loc || '',
                User: User || '',
                Active: active || '',
                Scg: Scg || '',
                Hosp: PHA_COM.Session.HOSPID
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
                        title: '库存项ID',
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
    },
    // 院区(判断医院授权，授权走授权数据集，不授权查询查询所有院区)
    CTHosNew: function (tablename) {
        var hospAutFlag = tkMakeServerCall('PHA.FACE.IN.Com', 'GetHospAut');
        if (hospAutFlag === 'Y') {
            return {
                url: this.Url + 'ClassName=PHA.STORE.Org&QueryName=CTHospitalWithBDP&tablename=' + tablename
            };
        } else {
            return {
                url: this.Url + 'ClassName=PHA.STORE.Org&QueryName=CTHospital'
            };
        }
    },
    // 管控级别
    CtrlLevel: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Drug&QueryName=CtrlLevel'
        };
    },
    // 职称
    PositionalTitles: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Org&QueryName=CTCarPrvTp'
        };
    },
    // 就诊类型
    Admtype: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Org&QueryName=Admtype'
        };
    },
    // 楼宇楼层
    BuildingFloor: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Org&QueryName=BuildingFloor&HospId=' + PHA_COM.Session.HOSPID
        };
    },
    //临购药品使用类型
    TmpDrugUseType: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Drug&QueryName=TmpDrugUseType'
        };
    },

    //病区病人的登记号
    PamiNoByWard: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Org&QueryName=PamiNoByWard&Ward=' + PHA_COM.Session.WARDID
        };
    },
    //登记号获取病人姓名
    NameByPamino: function (Pamino) {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Org&QueryName=NameByPamino&Pamino=' + Pamino // filterText
        };
    },
    // 临购单审核状态
    TmpDurgAuditStatus: function (ALLFlag) {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Drug&QueryName=TmpDurgAuditStatus&SessionUser=' + PHA_COM.Session.USERID + '&SessionHosp=' + PHA_COM.Session.HOSPID + '&ALLFlag=' + ALLFlag
        };
    },
    // 临购单入库状态
    TmpDurgIngdStatus: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Drug&QueryName=TmpDurgIngdStatus'
        };
    },
    // 临购单授权状态
    TmpDurgAuthStatus: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Drug&QueryName=TmpDurgAuthStatus'
        };
    },
    // 按科室拓展信息型获取科室
    DHCSTLoc: function (LocType) {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Org&QueryName=SerchLoc&LocType=' + LocType + '&HOSPID=' + PHA_COM.Session.HOSPID
        };
    },
    // 单位
    CTUOMWithInci: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Drug&QueryName=CTUOMWithInci&HospId=' + PHA_COM.Session.HOSPID
        };
    },

    // 库存授权科室
    GetGroupDept: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Org&QueryName=GetGroupDept&GroupId=' + PHA_COM.Session.GROUPID + '&LogLoc=' + PHA_COM.Session.CTLOCID + '&HospId=' + PHA_COM.Session.HOSPID
        };
    },
    // 科室类组授权
    LocStkCatGroup: function (Loc, User) {
        Loc = Loc || '';
        User = User || '';
        return {
            url: this.Url + 'ClassName=PHA.STORE.Org&QueryName=LocStkCatGroup&LocId=' + Loc + '&UserId=' + User
        };
    },
    // 科室组
    LocGroup: function (loc) {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Org&QueryName=LocGroup&LocId=' + loc
        };
    },
    // 业务类型
    BusinessType: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Drug&QueryName=BusinessType'
        };
    },
    // 供应商分类
    VendorCat: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Unit&QueryName=GetVendorCat&HospId=' + PHA_COM.Session.HOSPID
        };
    },
    // 供应商资质分类
    CertType: function (pType) {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Unit&QueryName=GetCertType&HospId=' + PHA_COM.Session.HOSPID + '&pType=' + pType
        };
    },
    // 接口字典表
    FaceDict: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Other&QueryName=QueryFaceDict&HospId=' + PHA_COM.Session.HOSPID
        };
    },
    // 部门组
    RBCDepartmentGroup: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Org&QueryName=RBCDepartmentGroup&HospId=' + PHA_COM.Session.HOSPID
        };
    },
    // 科室可登陆人员
    LocUser: function (Loc) {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Org&QueryName=LocUser&Loc=' + Loc
        };
    },
    // 省名称数据集
    Province: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Unit&QueryName=Province'
        };
    },
    // 市名称数据集
    City: function (Province) {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Unit&QueryName=City&Province=' + Province
        };
    },
    // 区县名称数据集
    CityArea: function (City) {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Unit&QueryName=CityArea&City=' + City
        };
    },
    // 科室货位
    LocStkBinDic: function (Loc) {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Org&QueryName=LocStkBinDic&Loc=' + Loc
        };
    },
    // 科室管理组
    LocManGrp: function (Loc) {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Org&QueryName=LocMagGrp&Loc=' + Loc
        };
    },
    // 科室组(药库)
    InLocGroup: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Org&QueryName=InLocGroup&HospId=' + PHA_COM.Session.HOSPID
        };
    },
    // 项目组
    LocItemGroup: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Org&QueryName=LocItemGroup&HospId=' + PHA_COM.Session.HOSPID
        };
    },
    // 库房类别
    StoreType: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Org&QueryName=StoreType'
        };
    },
    // 普通号
    CTCareProv: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Org&QueryName=CTCareProv&gHospId=' + PHA_COM.Session.HOSPID
        };
    },
    // 科室自定义分类
    LocCostomGroup: function (locId) {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Org&QueryName=LocCostomGroup&hospId=' + PHA_COM.Session.HOSPID + '&locId=' + locId
        };
    },
    // 科室自定义分类小类
    LocCostomGItm: function (lcg) {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Org&QueryName=LocCostomGItm&hospId=' + PHA_COM.Session.HOSPID + '&lcg=' + lcg
        };
    },
    // 药品自定义分类
    StatType: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Drug&QueryName=StatType&hospId=' + PHA_COM.Session.HOSPID
        };
    },
    // 药品自定义分类小类
    StatCat: function (pinst) {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Drug&QueryName=StatCat&hospId=' + PHA_COM.Session.HOSPID + '&pinst=' + pinst
        };
    },
    // 根据[供给科室ID]获取[请领科室]列表
    RelLocByPro: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Org&QueryName=RelLocByPro&hospId=' + PHA_COM.Session.HOSPID
        };
    },
    // 根据[请领科室ID]获取[供给科室]列表
    RelLocByRec: function (pinst) {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Org&QueryName=RelLocByRec&hospId=' + PHA_COM.Session.HOSPID
        };
    },

    /**
     * 通用业务状态
     * @param {String} busiCode 业务代码
     * @param {String} loc      科室, 后台目前主要依据院区区分, 此科室默认传登录科室即可
     * @param {String} user     登录用户
     * @returns
     */
    BusiProcess: function (busiCode, loc, user) {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Other&QueryName=BusiProcess&loc=' + loc + '&user=' + user + '&busiCode=' + busiCode
        };
    },
    /**
     * 付款方式
     * @param {*} params
     */
    CTPayMode: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Other&QueryName=CTPayMode'
        };
    },
    // 挂号职称
    RegisteredType: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Other&QueryName=RegisteredType&HospId=' + PHA_COM.Session.HOSPID
        };
    },
    // 子科室 | 备用药科室
    BaseDrugLoc: function (mainLoc) {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Org&QueryName=BaseDrugLoc&mainLoc=' + mainLoc
        };
    }
};
