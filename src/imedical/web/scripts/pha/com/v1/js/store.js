/**
 * ����:	 ҩ������-���ݼ�����
 * ��д��:	 yunhaibao
 * ��д����: 2019-03-12
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
            url: this.Url + 'ClassName=PHA.STORE.Org&QueryName=CTLoc&Type=E,EM&HospId=' + PHA_COM.Session.HOSPID
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
    WardLoc: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Org&QueryName=WardLoc&HospId=' + session['LOGON.HOSPID']
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
        return {
            url: this.Url + 'ClassName=PHA.STORE.Org&QueryName=SSUser&HospId=' + PHA_COM.Session.HOSPID
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
            url: this.Url + 'ClassName=PHA.STORE.Drug&QueryName=PHCDFCHPhSpecInstr'
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
                        title: 'arcimId',
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
                        title: 'chemId',
                        width: 50,
                        hidden: true
                    }
                ]
            ]
        };
    },
    // ����ͨ����
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
                        title: 'geneId',
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
                Active: active || ''
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
                        title: 'inciId',
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
    }
};
