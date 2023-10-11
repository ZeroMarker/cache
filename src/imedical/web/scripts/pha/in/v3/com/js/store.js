/**
 * 名称:   药库公共 - 数据集集合
 * 编写人:  Huxt
 * 编写日期: 2022-03-31
 * scripts/pha/in/v3/com/js/store.js
 */
var PHA_IN_STORE = {
    Url: $URL + '?ResultSetType=Array&',
    Hosp: session['LOGON.HOSPID'],
    Loc: session['LOGON.CTLOCID'],
    User: session['LOGON.USERID'],
    // 采购人员
    LocPurPlanUser: function (locId) {
        locId = locId || this.Loc;
        return {
            url: this.Url + 'ClassName=PHA.IN.Store.Org&QueryName=LocPurPlanUser&hospId=' + this.Hosp + '&locId=' + locId
        };
    },
    // 出/入库类型(qType:O-出库,I-入库)
    OperateType: function (qType) {
        qType = qType || 'O';
        return {
            url: this.Url + 'ClassName=PHA.IN.Store.Other&QueryName=OperateType&hospId=' + this.Hosp + '&qType=' + qType
        };
    },
    // 退货原因
    ReasonForReturn: function () {
        return {
            url: this.Url + 'ClassName=PHA.IN.Store.Other&QueryName=ReasonForReturn&hospId=' + this.Hosp
        };
    },
    // 库存调整原因
    ReasonForAdj: function () {
        return {
            url: this.Url + 'ClassName=PHA.IN.Store.Other&QueryName=ReasonForAdj&hospId=' + this.Hosp
        };
    },
    // 调价原因
    ReasonForAdjPrice: function () {
        return {
            url: this.Url + 'ClassName=PHA.IN.Store.Other&QueryName=ReasonForAdjPrice&hospId=' + this.Hosp
        };
    },
    // 报损原因
    ReasonForScrap: function () {
        return {
            url: this.Url + 'ClassName=PHA.IN.Store.Other&QueryName=ReasonForScrap&hospId=' + this.Hosp
        };
    },
    // 实盘窗口
    StkTkWindow: function (locId) {
        locId = locId || this.Loc;
        return {
            url: this.Url + 'ClassName=PHA.IN.Store.Other&QueryName=StkTkWindow&hospId=' + this.Hosp + '&locId=' + locId
        };
    },
	/* 业务流程
     * param : busiCode     业务代码
     *       : rangeFlag    使用范围 ( 
     *              CREATE      : 仅查询 SAVE，COMP
     *              COPY        : 仅查询 SAVE 的所有状态
     *              AUDIT       : 仅查询，除去 SAVE，COMP，CANCEL之后再除去 独立界面 的流程
     *              ALL || ""   : 查询所有--供查询界面使用)
     *         )
     *       : appointCode  指定业务代码 
     */
    BusiProcess: function (busiCode, rangeFlag, appointCode) {
        hospId = this.Hosp;
        userId = this.User;
        appointCode = appointCode || "";
        return {
            url: this.Url + 'ClassName=PHA.IN.Store.Other&QueryName=BusiPro&hospId=' + hospId + '&busiCode=' + busiCode + '&rangeFlag=' + rangeFlag + '&userId=' + userId + '&appointCode=' + appointCode
        };
    },
    /* 请求单执行状态
     * param : rangeFlag    使用范围 ( 
     *              CREATE      : 仅查询 SAVE，COMP
     *              TRANS       : 除了 SAVE
     *              ALL || ""   : 查询所有--供查询界面使用)
     *         )
     */
    ReqStauts: function (rangeFlag) {
        rangeFlag = rangeFlag || "";
        return {
            url: this.Url + 'ClassName=PHA.IN.Store.Other&QueryName=ReqStauts&rangeFlag=' + rangeFlag
        };
    },
    /* 申请类型 */
    ReqType: function () {
        return {
            url: this.Url + 'ClassName=PHA.IN.Store.Other&QueryName=ReqType'
        };
    },
    /* 业务类型
     * param : cancelFlag   撤销包含方式 ( 
     *              WITH           : 所有数据
     *              ONLY           : 仅取消业务类型
     *              WITHOUT || ""  : 仅查询非取消业务类型
     *         )
     */
    BusiType: function (cancelFlag) {
        cancelFlag = cancelFlag || "";
        return {
            url: this.Url + 'ClassName=PHA.IN.Store.Other&QueryName=BusiType&cancelFlag=' + cancelFlag
        };
    },
    /* 小数规则
     */
    DecimalRule : function (hospId) {
	    hospId = hospId || this.Hosp;
        return {
            url: this.Url + 'ClassName=PHA.IN.Store.Other&QueryName=DecimalRule&hospId=' + hospId
        };
    },
    /* 定价类型
     */
    MarkType : function (hospId) {
	    hospId = hospId || this.Hosp;
        return {
            url: this.Url + 'ClassName=PHA.IN.Store.Other&QueryName=MarkType&hospId=' + hospId
        };
    },
    /* (业务单据类型维护时)业务类型 */
    BusiForNoType : function (hospId) {
	    hospId = hospId || this.Hosp;
        return {
            url: this.Url + 'ClassName=PHA.IN.Store.Other&QueryName=BusiForNoType&hospId=' + hospId
        };
    },
    BusiStatusResult: function () {
        return {
            url: this.Url + 'ClassName=PHA.IN.Store.Other&QueryName=BusiStatusResult'
        };
    } ,
    // 货位树
    StkBinTree: function (Loc) {
        return {
            url: this.Url + 'ClassName=PHA.IN.Store.Other&MethodName=StkBinTree' + (Loc ? '&LocId=' + Loc : '')
        };
    },
    // 货位下拉框
    StkBinComb: function (Loc) {
        return {
            url: this.Url + 'ClassName=PHA.IN.Store.Other&QueryName=StkBinComb' + (Loc ? '&LocId=' + Loc : '')
        };
    },
    // 货位下拉框(仅货架号)
    StkBinRacks: function (Loc) {
        return {
            url: this.Url + 'ClassName=PHA.IN.Store.Other&QueryName=StkBinRacks' + (Loc ? '&LocId=' + Loc : '')
        };
    },  
}