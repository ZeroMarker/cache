/**
 * FileName: dhcbill.interface.js
 * Author: ZhYW
 * Date: 2021-12-01
 * Description: 计费医保组(计费)接口类库
 */

var BILL_INF = {
	apply: function(o, c, defaults) {
		if (defaults) {
			this.apply(o, defaults);   //如果有默认属性也复制到目标属性中
		}
		if (o instanceof Object && c instanceof Object) {
			$.each(Object.keys(c), function(i, p) {
				o[p] = c[p];          //将对象c中的数据全部copy到o中
			});
		}
		return o;
	}
};

(function() {
	BILL_INF.apply(BILL_INF, {
		//调用医生站接口，记录基础代码数据使用次数
		saveCTUseCount : function(t_name, t_id) {
			return tkMakeServerCall("DHCDoc.Log.DHCDocCTUseCount", "Save", t_name, t_id, session["LOGON.USERID"], "U", session["LOGON.USERID"])
		},
		//收银台接口
		showCheckout: function(obj) {
			return new Promise(function (resolve, reject) {
				var _title = obj.title || $g("收银台");
				delete obj.title;   //title为面板title，不需要传入url
				var _url = "dhcbill.checkout.csp?arguments=" + encodeURIComponent(JSON.stringify(obj));
				websys_showModal({
					url: _url,
					title: _title,
					iconCls: 'icon-w-card',
					height: 650,
					width: 1010,
					closable: false,
					callbackFunc: function(rtnValue) {
						if (rtnValue.code) {
							return resolve(rtnValue.message);
						}
						reject();
					}
				});
			});
		},
		//跳号接口
		showSkipInv: function(obj) {
			return new Promise(function (resolve, reject) {
				var _title = obj.title || $g("跳号");
				delete obj.title;   //title为面板title，不需要传入url
				var _url = "dhcbill.inv.skipinv.csp?arguments=" + encodeURIComponent(JSON.stringify(obj));
				websys_showModal({
					url: _url,
					title: _title,
					iconCls: 'icon-w-skip-no',
					width: 624,
					height: 225,
					callbackFunc: resolve
				});
			});
		},
		//门诊收费医嘱明细
		showOPChgOrdItm: function(obj) {
			var _title = obj.title || $g("医嘱明细");
			delete obj.title;   //title为面板title，不需要传入url
			var _url = "dhcbill.opbill.invoeitm.csp?arguments=" + encodeURIComponent(JSON.stringify(obj));
			websys_showModal({
				url: _url,
				title: _title,
				iconCls: 'icon-w-list',
				width: '80%',
				height: '80%'
			});
		},
		//住院交押金
		showPayDeposit: function(obj) {
			return new Promise(function (resolve, reject) {
				var _title = obj.title || $g("交押金");
				delete obj.title;   //title为面板title，不需要传入url
				var _url = "dhcbill.ipbill.deposit.pay.if.csp?EpisodeID=" + obj.EpisodeID + "&PayAmt=" + (obj.PayAmt || "") + "&TransferFlag=" + (obj.TransferFlag || "");
				websys_showModal({
					url: _url,
					title: _title,
					iconCls: 'icon-w-paid',
					width: '85%',
					height: '85%',
					onClose: function() {
						resolve();
					}
				});
			});
		},
		//住院退押金
		showRefDeposit: function(obj) {
			return new Promise(function (resolve, reject) {
				var _title = obj.title || $g("退押金");
				delete obj.title;   //title为面板title，不需要传入url
				var _url = "dhcbill.ipbill.deposit.refund.if.csp?EpisodeID=" + obj.EpisodeID + "&RefundAmt=" + (obj.RefundAmt || "");
				websys_showModal({
					url: _url,
					title: _title,
					iconCls: 'icon-w-paid',
					width: '85%',
					height: '85%',
					onClose: function() {
						resolve();
					}
				});
			});
		},
		//住院结算冲退押金明细
		showChgedDepList: function(obj) {
			return new Promise(function (resolve, reject) {
				var _title = obj.title || $g("结算押金明细");
				delete obj.title;   //title为面板title，不需要传入url
				var _url = "dhcbill.ipbill.chgeddeplist.csp?arguments=" + encodeURIComponent(JSON.stringify(obj));
				websys_showModal({
					url: _url,
					title: _title,
					iconCls: 'icon-w-list',
					width: 920,
					height: 450,
					onClose: function() {
						resolve();
					}
				});
			});
		},
		//调用基础平台组接口，将权力项申请按钮显示到界面上
		getStatusHtml: function(authCode, eId) {
			$.m({
				ClassName: "BSP.SYS.SRV.AuthItemApply",
				MethodName: "GetStatusHtml",
				AuthCode: authCode
			}, function(rtn) {
		    	if (rtn != "") {
		        	$(rtn).insertAfter("#" + eId);
		        	disableById(eId);
		        }
		    });
		}
	});
})();