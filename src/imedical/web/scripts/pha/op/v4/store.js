/**
 * ����:	 ����ҩ������-���ݼ�����
 * ��д��:	 zhaozhiduan
 * ��д����: 2020-09-24
 */

 var PHAOP_STORE = {
    Url: $URL + '?ResultSetType=Array&',
    RowUrl: $URL + '?ResultSetType=Array&',
    // ����ҩ��
    PHLOC: function () {
        return {
            url: this.Url + 'ClassName=PHA.OP.COM.Store&QueryName=GetPHAOPLoc&userId=' +session['LOGON.USERID']+'&hospId=' +PHA_COM.Session.HOSPID,
        };
    },
    // ����
    PhlWin: function () {
        return {
            url: this.Url + 'ClassName=PHA.OP.COM.Store&QueryName=GetPHAOPPhlWin',
        };
    },
    // ����ҩ����
    BaseLoc: function () {
        return {
            url: this.Url + 'ClassName=PHA.OP.COM.Store&QueryName=GetBaseLoc&hospId=' + PHA_COM.Session.HOSPID+'&type='+'O',
        };
    },
	// �û�Ȩ�޿���
    UserLoc: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Org&QueryName=UserLoc&UserId='+session['LOGON.USERID']+'&HospId=' +  PHA_COM.Session.HOSPID,
        };
    },
    // ���ҵ��û�
    SSUser: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Org&QueryName=SSUser&HospId=' +  PHA_COM.Session.HOSPID
        };
    },
    // ��������
    WinType: function () {
        return {
            url: this.Url + 'ClassName=PHA.OP.COM.Store&QueryName=PhWinType'
        }
    },
    // �����ҩ���û�
    PhPerson: function () {
        return {
            url: this.Url + 'ClassName=PHA.OP.COM.Store&QueryName=PhlPerson'
        };
    },
    // ȫ������
    CTLOC: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Org&QueryName=CTLoc&HospId=' +  PHA_COM.Session.HOSPID
        };
    },
    Instruction:function(){
		return {
            url: this.Url + 'ClassName=PHA.OP.COM.Store&QueryName=Instruction'
        };
	},
	PhlocFlow:function(){
		return {
            queryParams: {
                ClassName: 'PHA.OP.COM.Store',
                QueryName: 'PhlocFlow',
                locId:PHA_COM.Session.CTLOCID
            },
            panelWidth: 400,
            pagination: false,
            idField: 'RowId',
            textField: 'FlowShowDesc',
            columns: [
                [
                    {
                        field: 'FlowCode',
                        title: '��ҩ����',
                        width: 50
                    },{
                        field: 'FlowDesc',
                        title: '�䷢����',
                        width: 120
                    },
                    {
                        field: 'FlowDirDesc',
                        title: 'ֱ��ҩ����',
                        width: 120
                    },
                    {
                        field: 'RowId',
                        title: 'RowId',
                        width: 50,
                        hidden: true
                    },
                    {
                        field: 'FlowShowDesc',
                        title: 'RowId',
                        width: 50,
                        hidden: true
                    }
                ]
            ]
        };
	},
    ArcItm:function(){
	    return {
            queryParams: {
                ClassName: 'PHA.OP.COM.Store',
                QueryName: 'GetArcItmMast',
                HospId:PHA_COM.Session.HOSPID
            },
            panelWidth: 400,
            idField: 'arcItmRowId',
            textField: 'arcItmDesc',
            columns: [
                [
                    {
                        field: 'arcItmCode',
                        title: '����',
                        width: 100
                    },
                    {
                        field: 'arcItmDesc',
                        title: '����',
                        width: 250
                    },
                    {
                        field: 'arcItmRowId',
                        title: 'arcItmRowId',
                        width: 50,
                        hidden: true
                    }
                ]
            ]
        };
	},
	// ����
    EMLoc: function () {
        return {
            url: this.Url + 'ClassName=PHA.OP.COM.Store&QueryName=GetEMLoc&hospId=' + PHA_COM.Session.HOSPID,
        };
    },
	// �ܾ���ҩԭ��
    RefuseRetReason: function () {

        return {
            url: this.Url + 'ClassName=PHA.OP.COM.Util&MethodName=jsGetReturnRefuseReason&style=hisui&HospId=' + PHA_COM.Session.HOSPID,
        };
    },
    // ��ҩԭ��
    RetReason: function () {
        return {
            url: this.Url + 'ClassName=PHA.OP.COM.Util&MethodName=jsGetReturnReason&style=hisui&HospId=' + PHA_COM.Session.HOSPID,
        };
    },
    // �ܼ� 
    WeekDay: function () {
        return {
            url: this.Url + 'ClassName=PHA.OP.COM.Store&QueryName=GetWeekDay&hospId=' + PHA_COM.Session.HOSPID,
        };
    },
    // Ժ��ҩ��
    PhLocByHosp: function () {
        return {
            url: this.Url + 'ClassName=PHA.OP.COM.Store&QueryName=GetPhLocByHosp&hospId=' + PHA_COM.Session.HOSPID,
        };
    }
    
    
}
