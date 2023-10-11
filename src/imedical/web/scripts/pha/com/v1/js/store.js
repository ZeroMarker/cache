/**
 * ����:	 ҩ������-���ݼ�����
 * ��д��:	 yunhaibao
 * ��д����: 2019-03-12
 * Org-�����û������ݼ�;Drug-ҩƷ��Ϣ������ݼ�;Unit��Ӧ��,���ҵȵ�λ;Other-���������������������;
 * scripts/pha/com/v1/js/store.js
 */
var PHA_STORE = {
    Url: $URL + '?ResultSetType=Array&',
    RowUrl: $URL + '?ResultSetType=Array&',
    // Ժ��
    CTHospital: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Org&QueryName=CTHospital'
        };
    },
    // ��λ
    CTUOM: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Drug&QueryName=CTUOM&HospId=' + PHA_COM.Session.HOSPID
        };
    },
    // ����
    PHCForm: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Drug&QueryName=PHCForm'
        };
    },
    // �Ƴ�
    PHCDuration: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Drug&QueryName=PHCDuration'
        };
    },
    // Ƶ��
    PHCFreq: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Drug&QueryName=PHCFreq'
        };
    },
    // ���Ʒ���
    PHCPoison: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Drug&QueryName=PHCPoison'
        };
    },
    // �û�Ȩ�޿���
    UserLoc: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Org&QueryName=UserLoc&HospId=' + PHA_COM.Session.HOSPID
        };
    },
    /**
     * ҩ��
     * @param {String} type OP-����,IP-סԺ,��-����
     */
    Pharmacy: function (type) {
        type = type || '';
        return {
            url: this.Url + 'ClassName=PHA.STORE.Org&QueryName=Pharmacy&Type=' + type + '&HospId=' + PHA_COM.Session.HOSPID
        };
    },
    // ҽ������
    DocLoc: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Org&QueryName=CTLoc&TypeStr=E,EM,O,OP,IP&HospId=' + PHA_COM.Session.HOSPID
        };
    },
    // ���п���
    CTLoc: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Org&QueryName=CTLoc&HospId=' + PHA_COM.Session.HOSPID
        };
    },
    // ��������
    EMLGLoc: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Org&QueryName=EMLGLoc&HospId=' + PHA_COM.Session.HOSPID
        };
    },
    // ���� CTLOC��ID
    WardLoc: function (cspName, SRLSelectCode) {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Org&QueryName=WardLoc&HospId=' + PHA_COM.Session.HOSPID + '&cspName=' + cspName + '&SRLSelectCode=' + SRLSelectCode
        };
    },
    // ���տ��Ҷ�Ӧ�Ĳ��� CTLOC��ID  by zhaoxinlong 2022.04.24
    WardLocByRecLoc: function (cspName, SRLSelectCode) {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Org&QueryName=WardLocByRecLoc&HospId=' + PHA_COM.Session.HOSPID + '&cspName=' + cspName + '&SRLSelectCode=' + SRLSelectCode
        };
    },
    // ҽ��
    Doctor: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Org&QueryName=Doctor&HospId=' + PHA_COM.Session.HOSPID
        };
    },
    // ҩʦ
    Pharmacist: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Org&QueryName=Pharmacist&HospId=' + PHA_COM.Session.HOSPID
        };
    },
    // �û�
    SSUser: function (locId, onlyDef) {
        locId = locId || '';
        return {
            url: this.Url + 'ClassName=PHA.STORE.Org&QueryName=SSUser&HospId=' + PHA_COM.Session.HOSPID + '&LocId=' + locId
        };
    },
    // ��ȫ��
    SSGroup: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Org&QueryName=SSGroup&HospId=' + PHA_COM.Session.HOSPID
        };
    },
    // �ѱ�
    PACAdmReason: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Other&QueryName=PACAdmReason&HospId=' + PHA_COM.Session.HOSPID
        };
    },
    // ���ô���
    ARCBillGrp: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Drug&QueryName=ARCBillGrp&HospId=' + PHA_COM.Session.HOSPID
        };
    },
    // ��������
    ARCBillSub: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Drug&QueryName=ARCBillSub&HospId=' + PHA_COM.Session.HOSPID
        };
    },
    // ҽ������
    OECOrderCategory: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Drug&QueryName=OECOrderCategory&HospId=' + PHA_COM.Session.HOSPID
        };
    },
    // ҽ������
    ARCItemCat: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Drug&QueryName=ARCItemCat&HospId=' + PHA_COM.Session.HOSPID
        };
    },
    // ��Σ����
    PHCDFHighRisk: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Drug&QueryName=PHCDFHighRisk'
        };
    },
    // ^DHCSTOFFICODE,��׼�ĺ�ǰ׺��(Gpp,Gp)
    // Gpp:����ҩ����,Gp:��ҩ׼��ǰ׺
    DHCSTOFFICODE: function (type) {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Drug&QueryName=DHCSTOFFICODE&Type=' + type
        };
    },
    // ҽ�����ȼ�
    OECPriority: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Drug&QueryName=OECPriority'
        };
    },
    // �÷�
    PHCInstruc: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Drug&QueryName=PHCInstruc'
        };
    },
    // ��ҩ��ע
    PHCDFCHPhSpecInstr: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Drug&QueryName=PHCDFCHPhSpecInstr&HospId=' + PHA_COM.Session.HOSPID
        };
    },
    // ����
    DHCStkCatGroup: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Drug&QueryName=DHCStkCatGroup&HospId=' + PHA_COM.Session.HOSPID
        };
    },
    // ������
    INCStkCat: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Drug&QueryName=INCStkCat&HospId=' + PHA_COM.Session.HOSPID
        };
    },
    // ��������
    DHCMarkType: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Drug&QueryName=DHCMarkType&HospId=' + PHA_COM.Session.HOSPID
        };
    },
    // �������
    DHCItmQualityLevel: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Drug&QueryName=DHCItmQualityLevel&HospId=' + PHA_COM.Session.HOSPID
        };
    },
    // ������ҩԭ��
    DHCStkRefuseRetReason: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Drug&QueryName=DHCStkRefuseRetReason&HospId=' + PHA_COM.Session.HOSPID
        };
    },
    // ������ԭ��
    DHCItmNotUseReason: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Drug&QueryName=DHCItmNotUseReason&HospId=' + PHA_COM.Session.HOSPID
        };
    },
    // �²�����ҳ����
    DHCTarMCCateNew: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Drug&QueryName=DHCTarMCCateNew&HospId=' + PHA_COM.Session.HOSPID
        };
    },
    // ������ҳ����
    DHCTarMCCate: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Drug&QueryName=DHCTarMRCate&HospId=' + PHA_COM.Session.HOSPID
        };
    },
    // ��������
    DHCTarEMCCate: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Drug&QueryName=DHCTarEMCCate&HospId=' + PHA_COM.Session.HOSPID
        };
    },
    // �����ӷ���
    DHCTarOutpatCate: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Drug&QueryName=DHCTarOutpatCate&HospId=' + PHA_COM.Session.HOSPID
        };
    },
    // סԺ�ӷ���
    DHCTarInpatCate: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Drug&QueryName=DHCTarInpatCate&HospId=' + PHA_COM.Session.HOSPID
        };
    },
    // ����ӷ���
    DHCTarAcctCate: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Drug&QueryName=DHCTarAcctCate&HospId=' + PHA_COM.Session.HOSPID
        };
    },
    // �շ�����
    DHCTarSubCate: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Drug&QueryName=DHCTarSubCate&HospId=' + PHA_COM.Session.HOSPID
        };
    },
    // ������ҵ,������
    DHCCarrier: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Unit&QueryName=DHCCarrier&HospId=' + PHA_COM.Session.HOSPID
        };
    },
    // ��Ӫ��ҵ,��Ӧ��
    APCVendor: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Unit&QueryName=APCVendor&HospId=' + PHA_COM.Session.HOSPID
        };
    },
    // ������ҵ,����
    PHManufacturer: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Unit&QueryName=PHManufacturer&HospId=' + PHA_COM.Session.HOSPID
        };
    },
    // �б�����
    DHCPublicBiddingList: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Drug&QueryName=DHCPublicBiddingList&HospId=' + PHA_COM.Session.HOSPID
        };
    },
    // �б꼶��
    DHCItmPBLevel: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Drug&QueryName=DHCItmPBLevel&HospId=' + PHA_COM.Session.HOSPID
        };
    },
    // �˲�����
    DHCSTBookCat: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Drug&QueryName=DHCSTBookCat&HospId=' + PHA_COM.Session.HOSPID
        };
    },
    // ҩƷ�׻�������
    DHCINCEasyConDescType: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Drug&QueryName=DHCINCEasyConDescType'
        };
    },
    // ������
    DHCCardTypeDef: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Org&QueryName=DHCCardTypeDef'
        };
    },
    // ҽ����
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
                        title: '����',
                        width: 100
                    },
                    {
                        field: 'arcimDesc',
                        title: '����',
                        width: 250
                    },
                    {
                        field: 'arcimId',
                        title: 'ҽ����ID',
                        width: 50,
                        hidden: true
                    }
                ]
            ]
        };
    },
    // Ʒ��ͨ����
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
                        title: '����',
                        width: 150
                    },
                    {
                        field: 'chemDesc',
                        title: '����',
                        width: 275
                    },
                    {
                        field: 'chemId',
                        title: 'Ʒ��ͨ����ID',
                        width: 50,
                        hidden: true
                    }
                ]
            ]
        };
    },
    // ����ͨ����
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
                        title: '����',
                        width: 150
                    },
                    {
                        field: 'geneName',
                        title: '����',
                        width: 275
                    },
                    {
                        field: 'geneId',
                        title: '����ͨ����ID',
                        width: 50,
                        hidden: true
                    }
                ]
            ]
        };
    },
    // �����
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
                        title: '����',
                        width: 100
                    },
                    {
                        field: 'inciDesc',
                        title: '����',
                        width: 250
                    },
                    {
                        field: 'inciId',
                        title: '�����ID',
                        width: 50,
                        hidden: true
                    }
                ]
            ]
        };
    },
    // �����(�ٹ�ҩƷ)
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
                        title: '����',
                        width: 100
                    },
                    {
                        field: 'inciDesc',
                        title: '����',
                        width: 250
                    },
                    {
                        field: 'inciId',
                        title: '�����ID',
                        width: 50,
                        hidden: true
                    }
                ]
            ]
        };
    },
    // ����ҩƷ�����(�ж�����Ȩ��)
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
                        title: '����',
                        width: 100
                    },
                    {
                        field: 'inciDesc',
                        title: '����',
                        width: 250
                    },
                    {
                        field: 'inciId',
                        title: '�����ID',
                        width: 50,
                        hidden: true
                    }
                ]
            ]
        };
    },
    // WHONET��
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
                        title: '����',
                        width: 100
                    },
                    {
                        field: 'antName',
                        title: '����',
                        width: 200
                    },
                    {
                        field: 'antEName',
                        title: 'Ӣ������',
                        width: 250
                    }
                ]
            ]
        };
    },
    // ҩƷ����ͨ���ֵ� - û�����������ʹ��ascode
    ComDictionary: function (DicType) {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Drug&QueryName=StkComDictionary&ScdType=' + DicType
        };
    },
    // ҩƷ����ͨ���ֵ�,�Դ���ΪID
    ComDictionaryAsCode: function (DicType) {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Drug&QueryName=StkComDictionaryAsCode&ScdType=' + DicType
        };
    },
    // �ɹ��ƻ�����
    PurPlanType: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Drug&QueryName=PurPlanType'
        };
    },
    // ����
    DHCSTOrigin: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Unit&QueryName=DHCSTOrigin&HospId=' + PHA_COM.Session.HOSPID
        };
    },
    // WHODDD��λ
    WHODDDUOM: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Drug&QueryName=WHODDDUOM'
        };
    },
    // Ժ��(�ж�ҽԺ��Ȩ����Ȩ����Ȩ���ݼ�������Ȩ��ѯ��ѯ����Ժ��)
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
    // �ܿؼ���
    CtrlLevel: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Drug&QueryName=CtrlLevel'
        };
    },
    // ְ��
    PositionalTitles: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Org&QueryName=CTCarPrvTp'
        };
    },
    // ��������
    Admtype: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Org&QueryName=Admtype'
        };
    },
    // ¥��¥��
    BuildingFloor: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Org&QueryName=BuildingFloor&HospId=' + PHA_COM.Session.HOSPID
        };
    },
    //�ٹ�ҩƷʹ������
    TmpDrugUseType: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Drug&QueryName=TmpDrugUseType'
        };
    },

    //�������˵ĵǼǺ�
    PamiNoByWard: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Org&QueryName=PamiNoByWard&Ward=' + PHA_COM.Session.WARDID
        };
    },
    //�ǼǺŻ�ȡ��������
    NameByPamino: function (Pamino) {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Org&QueryName=NameByPamino&Pamino=' + Pamino // filterText
        };
    },
    // �ٹ������״̬
    TmpDurgAuditStatus: function (ALLFlag) {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Drug&QueryName=TmpDurgAuditStatus&SessionUser=' + PHA_COM.Session.USERID + '&SessionHosp=' + PHA_COM.Session.HOSPID + '&ALLFlag=' + ALLFlag
        };
    },
    // �ٹ������״̬
    TmpDurgIngdStatus: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Drug&QueryName=TmpDurgIngdStatus'
        };
    },
    // �ٹ�����Ȩ״̬
    TmpDurgAuthStatus: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Drug&QueryName=TmpDurgAuthStatus'
        };
    },
    // ��������չ��Ϣ�ͻ�ȡ����
    DHCSTLoc: function (LocType) {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Org&QueryName=SerchLoc&LocType=' + LocType + '&HOSPID=' + PHA_COM.Session.HOSPID
        };
    },
    // ��λ
    CTUOMWithInci: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Drug&QueryName=CTUOMWithInci&HospId=' + PHA_COM.Session.HOSPID
        };
    },

    // �����Ȩ����
    GetGroupDept: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Org&QueryName=GetGroupDept&GroupId=' + PHA_COM.Session.GROUPID + '&LogLoc=' + PHA_COM.Session.CTLOCID + '&HospId=' + PHA_COM.Session.HOSPID
        };
    },
    // ����������Ȩ
    LocStkCatGroup: function (Loc, User) {
        Loc = Loc || '';
        User = User || '';
        return {
            url: this.Url + 'ClassName=PHA.STORE.Org&QueryName=LocStkCatGroup&LocId=' + Loc + '&UserId=' + User
        };
    },
    // ������
    LocGroup: function (loc) {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Org&QueryName=LocGroup&LocId=' + loc
        };
    },
    // ҵ������
    BusinessType: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Drug&QueryName=BusinessType'
        };
    },
    // ��Ӧ�̷���
    VendorCat: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Unit&QueryName=GetVendorCat&HospId=' + PHA_COM.Session.HOSPID
        };
    },
    // ��Ӧ�����ʷ���
    CertType: function (pType) {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Unit&QueryName=GetCertType&HospId=' + PHA_COM.Session.HOSPID + '&pType=' + pType
        };
    },
    // �ӿ��ֵ��
    FaceDict: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Other&QueryName=QueryFaceDict&HospId=' + PHA_COM.Session.HOSPID
        };
    },
    // ������
    RBCDepartmentGroup: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Org&QueryName=RBCDepartmentGroup&HospId=' + PHA_COM.Session.HOSPID
        };
    },
    // ���ҿɵ�½��Ա
    LocUser: function (Loc) {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Org&QueryName=LocUser&Loc=' + Loc
        };
    },
    // ʡ�������ݼ�
    Province: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Unit&QueryName=Province'
        };
    },
    // ���������ݼ�
    City: function (Province) {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Unit&QueryName=City&Province=' + Province
        };
    },
    // �����������ݼ�
    CityArea: function (City) {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Unit&QueryName=CityArea&City=' + City
        };
    },
    // ���һ�λ
    LocStkBinDic: function (Loc) {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Org&QueryName=LocStkBinDic&Loc=' + Loc
        };
    },
    // ���ҹ�����
    LocManGrp: function (Loc) {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Org&QueryName=LocMagGrp&Loc=' + Loc
        };
    },
    // ������(ҩ��)
    InLocGroup: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Org&QueryName=InLocGroup&HospId=' + PHA_COM.Session.HOSPID
        };
    },
    // ��Ŀ��
    LocItemGroup: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Org&QueryName=LocItemGroup&HospId=' + PHA_COM.Session.HOSPID
        };
    },
    // �ⷿ���
    StoreType: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Org&QueryName=StoreType'
        };
    },
    // ��ͨ��
    CTCareProv: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Org&QueryName=CTCareProv&gHospId=' + PHA_COM.Session.HOSPID
        };
    },
    // �����Զ������
    LocCostomGroup: function (locId) {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Org&QueryName=LocCostomGroup&hospId=' + PHA_COM.Session.HOSPID + '&locId=' + locId
        };
    },
    // �����Զ������С��
    LocCostomGItm: function (lcg) {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Org&QueryName=LocCostomGItm&hospId=' + PHA_COM.Session.HOSPID + '&lcg=' + lcg
        };
    },
    // ҩƷ�Զ������
    StatType: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Drug&QueryName=StatType&hospId=' + PHA_COM.Session.HOSPID
        };
    },
    // ҩƷ�Զ������С��
    StatCat: function (pinst) {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Drug&QueryName=StatCat&hospId=' + PHA_COM.Session.HOSPID + '&pinst=' + pinst
        };
    },
    // ����[��������ID]��ȡ[�������]�б�
    RelLocByPro: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Org&QueryName=RelLocByPro&hospId=' + PHA_COM.Session.HOSPID
        };
    },
    // ����[�������ID]��ȡ[��������]�б�
    RelLocByRec: function (pinst) {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Org&QueryName=RelLocByRec&hospId=' + PHA_COM.Session.HOSPID
        };
    },

    /**
     * ͨ��ҵ��״̬
     * @param {String} busiCode ҵ�����
     * @param {String} loc      ����, ��̨Ŀǰ��Ҫ����Ժ������, �˿���Ĭ�ϴ���¼���Ҽ���
     * @param {String} user     ��¼�û�
     * @returns
     */
    BusiProcess: function (busiCode, loc, user) {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Other&QueryName=BusiProcess&loc=' + loc + '&user=' + user + '&busiCode=' + busiCode
        };
    },
    /**
     * ���ʽ
     * @param {*} params
     */
    CTPayMode: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Other&QueryName=CTPayMode'
        };
    },
    // �Һ�ְ��
    RegisteredType: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Other&QueryName=RegisteredType&HospId=' + PHA_COM.Session.HOSPID
        };
    },
    // �ӿ��� | ����ҩ����
    BaseDrugLoc: function (mainLoc) {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Org&QueryName=BaseDrugLoc&mainLoc=' + mainLoc
        };
    }
};
