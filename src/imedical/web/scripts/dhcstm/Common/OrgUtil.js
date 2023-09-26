// /名称: 组织类别Combo
// /描述: 组织类别Combo
// /编写者：zhangdongmei
// /编写日期: 2011.10.11
var DictUrl = "dhcstm.";
var GroupId = session['LOGON.GROUPID'];
var gLocId = session['LOGON.CTLOCID'];
/*
 * 授权科室ComboBox
 */
var GetGroupDeptStore = new Ext.data.Store({
	proxy : new Ext.data.HttpProxy({
		url:'dhcstm.orgutil.csp?actiontype=GetGroupDept&start=0&limit=999&groupId='+GroupId+'&locDesc='
	}),
	reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['Description', 'RowId', 'Code'])
});


/*
 * 供应商分类ComboBox
 */
var GetVendorCatStore = new Ext.data.Store({
	proxy : new Ext.data.HttpProxy({
		url:'dhcstm.orgutil.csp?actiontype=GetVendorCat&start=0&limit=100'
	}),
	reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['Description', 'RowId'])
});



/*
 * 药房ComboBox
 */
var PhaDeptStore = new Ext.data.Store({
	proxy : new Ext.data.HttpProxy({
		url : DictUrl
				+ 'orgutil.csp?actiontype=PhaDept&start=0&limit=100'
	}),
	reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['Description', 'RowId'])
});


/*
 * 科室ComboBox
 */
var DeptLocStore = new Ext.data.Store({
	proxy : new Ext.data.HttpProxy({
		url : DictUrl
				+ 'orgutil.csp?actiontype=DeptLoc&start=0&limit=200'
	}),
	reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['Description', 'RowId'])
});

/*
 * 临床科室ComboBox
 */
var ClinicDeptStore = new Ext.data.Store({
	proxy : new Ext.data.HttpProxy({
		url : DictUrl
				+ 'orgutil.csp?actiontype=ClinicDept&start=0&limit=200'
	}),
	reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['Description', 'RowId'])
});

/*
 * 供应商ComboBox
 */
var APCVendorStore = new Ext.data.Store({
	proxy : new Ext.data.HttpProxy({
		url : 'dhcstm.orgutil.csp?actiontype=APCVendor'
	}),
	reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['Description', 'RowId'])
});

/*
 * 生产厂商ComboBox
 */
var PhManufacturerStore = new Ext.data.Store({
	proxy : new Ext.data.HttpProxy({
		url : 'dhcstm.orgutil.csp?actiontype=PhManufacturer'
	}),
	reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['Description', 'RowId'])
});


/*
 * 招标配送商ComboBox
 */
var CarrierStore = new Ext.data.Store({
			proxy : new Ext.data.HttpProxy({
						url : 'dhcstm.orgutil.csp?actiontype=Carrier&start=0&limit=999'
					}),
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['Description', 'RowId']),
			baseParams:{CADesc:''}
		});
		
/*
 * 科室组
 */
var StkLocGrpStore = new Ext.data.Store({
			proxy : new Ext.data.HttpProxy({
						url : 'dhcstm.orgutil.csp?actiontype=StkLocGrp&str=&start=0&limit=999'
					}),
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['Description', 'RowId'])
		});
		
		
/*
 * 科室项目组
 */
var StkItemGrpStore = new Ext.data.Store({
			proxy : new Ext.data.HttpProxy({
						url : 'dhcstm.orgutil.csp?actiontype=StkItemGrp&str=&start=0&limit=999'
					}),
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['Description', 'RowId'])
		});
		
/*
 * 发药窗口
 */
var PhaWindowStore = new Ext.data.Store({
			proxy : new Ext.data.HttpProxy({
						url : 'dhcstm.orgutil.csp?actiontype=GetPhaWindow&LocId=&start=0&limit=999'
					}),
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['Description', 'RowId'])
		});
		
/*
 * 某科室下的人员
 */
var DeptUserStore = new Ext.data.Store({
			proxy : new Ext.data.HttpProxy({
						url : 'dhcstm.orgutil.csp?actiontype=GetDeptUser&locId=&Desc=&start=0&limit=999'
					}),
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['Description', 'RowId'])
		});
		
/*
 * 科室管理组
 */
var LocManGrpStore = new Ext.data.Store({
			proxy : new Ext.data.HttpProxy({
						url : 'dhcstm.orgutil.csp?actiontype=GetLocManGrp&start=0&limit=999'
					}),
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['Description', 'RowId'])
		});
		
/*
 * 采购员ComboBox依据安全组
 */
 /*
var PurchaseUserStore = new Ext.data.Store({
			proxy : new Ext.data.HttpProxy({
						url : DictUrl
								+ 'orgutil.csp?actiontype=GroupUser&start=0&limit=999'
					}),
			baseParams:{'GrpDesc':'采购'},
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['Description', 'RowId'])
		});
*/
/*
 * 采购员ComboBox依据后台维护
*/
var PurchaseUserStore = new Ext.data.Store({
			proxy : new Ext.data.HttpProxy({
						url : DictUrl
								+ 'orgutil.csp?actiontype=LocPPLUser&start=0&limit=999'
					}),
			baseParams:{'locId':gLocId},
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['Description', 'RowId', 'Default'])
		});



/*
 * 实盘窗口
 */
var INStkTkWindowStore = new Ext.data.Store({
			proxy : new Ext.data.HttpProxy({
						url : DictUrl+'orgutil.csp?actiontype=GetInStkTkWindow&LocId=&start=0&limit=999'
					}),
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['Description', 'RowId'])
		});
		
 /* 
  * 取设置的供应科室*/		
var frLocListStore = new Ext.data.Store({
			proxy : new Ext.data.HttpProxy({
						url : DictUrl+'orgutil.csp?actiontype=GetFrLoc&LocId=&start=0&limit=999'
					}),
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['Description', 'RowId','LOCDefault'])

		});
/* 
  * 取设置的请求科室*/			
var toLocListStore = new Ext.data.Store({
			proxy : new Ext.data.HttpProxy({
						url : DictUrl+'orgutil.csp?actiontype=GetToLoc&LocId=&start=0&limit=999'
					}),
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['Description', 'RowId'])
		});
var LocListByMainLocStore=new Ext.data.Store({
			proxy : new Ext.data.HttpProxy({
						url : DictUrl+'orgutil.csp?actiontype=LocListByMainLoc'
					}),
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows',
						id:'RowId'
					}, ['Description', 'RowId'])
		});

 /** 
  * 取当前科室所在的科室组内的科室信息*/
var LocInSLGStore = new Ext.data.Store({
			proxy : new Ext.data.HttpProxy({
						url : DictUrl+'orgutil.csp?actiontype=GetLocInSLGByLoc'
					}),
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows',
						id:'RowId'
					}, ['Description', 'RowId'])
		});

/**
 * 科室人员combo
 */
var UStore = new Ext.data.Store({
			proxy : new Ext.data.HttpProxy({
						url : 'dhcstm.orgutil.csp?actiontype=StkLocUserCatGrp'
					}),
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['Description', 'RowId'])
		});

/**
 * 二级库专业组store
 */
var UserGroupStore = new Ext.data.Store({
			url : "dhcstm.sublocusergroupaction.csp?actiontype=FilterLocGroupList",
			reader : new Ext.data.JsonReader({
						totalProperty : 'results',
						root : "rows",
						idProperty : 'RowId'
					}, ['RowId', 'Description'])
		});

/**
 * 取某一科室所支配的科室
 */
var VirturalLocStore = new Ext.data.Store({
			url : 'dhcstm.orgutil.csp?actiontype=GetLocByMainLoc',
			reader : new Ext.data.JsonReader({
						totalProperty : 'results',
						root : "rows",
						idProperty : 'RowId'
					}, ['RowId', 'Description'])
		});
var SourceOfFundStore=new Ext.data.Store({
			url : 'dhcstm.orgutil.csp?actiontype=GetSourceOfFund',
			reader : new Ext.data.JsonReader({
						totalProperty : 'results',
						root : "rows",
						idProperty : 'RowId'
					}, ['RowId', 'Description'])
		});
/**
 * 获取所有user数据
 */
var AllUserStore = new Ext.data.JsonStore({
	url : 'dhcstm.orgutil.csp?actiontype=GetAllUser',
	totalProperty : 'results',
	root : "rows",
	fields : ['RowId', 'Description']
});

/**
 * defLoc
 */
var LeadLocStore = new Ext.data.JsonStore({
			url : 'dhcstm.orgutil.csp?actiontype=GetGroupLeadDept',
			totalProperty : "results",
			root : 'rows',
			fields : ["RowId", "Description"]
		});
/**
 * 库房类型为 器械材料的科室
 */		
var LocInfoStore = new Ext.data.Store({
			proxy : new Ext.data.HttpProxy({
						url : 'dhcstm.orgutil.csp?actiontype=LocInfo&str=&start=0&limit=999'
					}),
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['Description', 'RowId'])
		});
 /* 
  * 取标准名称20190412*/		
var StandardNameStore = new Ext.data.Store({
			proxy : new Ext.data.HttpProxy({
						url : DictUrl+'orgutil.csp?actiontype=GetStandardName&Desc=&start=0&limit=999'
					}),
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['Description', 'RowId'])

		});		