/**
 * 名称:	 门诊药房公共-数据集集合
 * 编写人:	 zhaozhiduan
 * 编写日期: 2020-09-24
 */

 var PHAOP_STORE = {
    Url: $URL + '?ResultSetType=Array&',
    RowUrl: $URL + '?ResultSetType=Array&',
    // 门诊药房
    PHLOC: function () {
        return {
            url: this.Url + 'ClassName=PHA.OP.COM.Store&QueryName=GetPHAOPLoc&userId=' +session['LOGON.USERID']+'&hospId=' +PHA_COM.Session.HOSPID,
        };
    },
    // 窗口
    PhlWin: function () {
        return {
            url: this.Url + 'ClassName=PHA.OP.COM.Store&QueryName=GetPHAOPPhlWin',
        };
    },
    // 基数药科室
    BaseLoc: function () {
        return {
            url: this.Url + 'ClassName=PHA.OP.COM.Store&QueryName=GetBaseLoc&hospId=' + PHA_COM.Session.HOSPID+'&type='+'O',
        };
    },
	// 用户权限科室
    UserLoc: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Org&QueryName=UserLoc&UserId='+session['LOGON.USERID']+'&HospId=' +  PHA_COM.Session.HOSPID,
        };
    },
    // 科室的用户
    SSUser: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Org&QueryName=SSUser&HospId=' +  PHA_COM.Session.HOSPID
        };
    },
    // 窗口类型
    WinType: function () {
        return {
            url: this.Url + 'ClassName=PHA.OP.COM.Store&QueryName=PhWinType'
        }
    },
    // 门诊的药房用户
    PhPerson: function () {
        return {
            url: this.Url + 'ClassName=PHA.OP.COM.Store&QueryName=PhlPerson'
        };
    },
    // 全部科室
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
                        title: '发药流程',
                        width: 50
                    },{
                        field: 'FlowDesc',
                        title: '配发流程',
                        width: 120
                    },
                    {
                        field: 'FlowDirDesc',
                        title: '直发药流程',
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
                        title: '代码',
                        width: 100
                    },
                    {
                        field: 'arcItmDesc',
                        title: '名称',
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
	// 留观
    EMLoc: function () {
        return {
            url: this.Url + 'ClassName=PHA.OP.COM.Store&QueryName=GetEMLoc&hospId=' + PHA_COM.Session.HOSPID,
        };
    },
	// 拒绝退药原因
    RefuseRetReason: function () {

        return {
            url: this.Url + 'ClassName=PHA.OP.COM.Util&MethodName=jsGetReturnRefuseReason&style=hisui&HospId=' + PHA_COM.Session.HOSPID,
        };
    },
    // 退药原因
    RetReason: function () {
        return {
            url: this.Url + 'ClassName=PHA.OP.COM.Util&MethodName=jsGetReturnReason&style=hisui&HospId=' + PHA_COM.Session.HOSPID,
        };
    },
    // 周几 
    WeekDay: function () {
        return {
            url: this.Url + 'ClassName=PHA.OP.COM.Store&QueryName=GetWeekDay&hospId=' + PHA_COM.Session.HOSPID,
        };
    },
    // 院区药房
    PhLocByHosp: function () {
        return {
            url: this.Url + 'ClassName=PHA.OP.COM.Store&QueryName=GetPhLocByHosp&hospId=' + PHA_COM.Session.HOSPID,
        };
    }
    
    
}
