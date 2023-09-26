// /名称: 物资相关信息Store
// /描述: 物资相关信息Store
// /编写者：zhangdongmei
// /编写日期: 2012.05.07
var DictUrl = "dhcstm.";

/*
 * 医院
 */
var HospStore = new Ext.data.Store({
			proxy : new Ext.data.HttpProxy({
						url : 'dhcstm.drugutil.csp?actiontype=Hosp&start=0&limit=999'
					}),
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['Description', 'RowId'])
		});

/*
 * 单位
 */
var CTUomStore = new Ext.data.Store({
			proxy : new Ext.data.HttpProxy({
						url : 'dhcstm.drugutil.csp?actiontype=CTUom&start=0&limit=999'
					}),
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['Description', 'RowId'])
		});

var CONUomStore = new Ext.data.Store({
			proxy : new Ext.data.HttpProxy({
						url : 'dhcstm.drugutil.csp?actiontype=CONUom&start=0&limit=999'
					}),
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['Description', 'RowId']),
			baseParams:{UomId:''}
		});

var ItmUomStore = new Ext.data.Store({
			proxy : new Ext.data.HttpProxy({
						url : 'dhcstm.drugutil.csp?actiontype=INCIUom&ItmRowid='
					}),
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['Description', 'RowId'])
		});
		/*
 * 规格类别ComboBox
 */
var SpecDescStore = new Ext.data.Store({
	proxy : new Ext.data.HttpProxy({
		url : 'dhcstm.drugutil.csp?actiontype=GetSpec&SpecItmRowId='
	}),
	reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['Description', 'RowId'])
});

/*
 * 库存类组ComboBox
 */
var IncScStkGrpStore = new Ext.data.Store({
	proxy : new Ext.data.HttpProxy({
		url : 'dhcstm.drugutil.csp?actiontype=INCSCStkGrp&StkType=M&start=0&limit=200'
	}),
	reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['Description', 'RowId'])
});

/*
 * 库存分类ComboBox
 */
var StkCatStore = new Ext.data.Store({
	proxy : new Ext.data.HttpProxy({
				url :'dhcstm.drugutil.csp?actiontype=StkCat'
			}),
	reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['Description', 'RowId'])
});

/*
 * 药学大类ComboBox
 */
var PhcCatStore = new Ext.data.Store({
	proxy : new Ext.data.HttpProxy({
				url : 'dhcstm.drugutil.csp?actiontype=PhcCat&start=0&limit=999'
			}),
	reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['Description', 'RowId']),
	baseParams:{PhccDesc:''}
});

/*
 * 药学子类ComboBox
 */
var PhcSubCatStore = new Ext.data.Store({
	proxy : new Ext.data.HttpProxy({
		url : 'dhcstm.drugutil.csp?actiontype=PhcSubCat&start=0&limit=999'
	}),
	reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['Description', 'RowId']),
	baseParams:{PhcCatId:''}
});


/*
 * 药学小类ComboBox
 */
var PhcMinCatStore = new Ext.data.Store({
	proxy : new Ext.data.HttpProxy({
		url : 'dhcstm.drugutil.csp?actiontype=PhcMinCat&start=0&limit=999'
	}),
	reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['Description', 'RowId']),
	baseParams:{PhcSubCatId:''}
});

/*
 * 处方通用名ComboBox
 */
var PhcGenericStore = new Ext.data.Store({
	proxy : new Ext.data.HttpProxy({
		url : 'dhcstm.drugutil.csp?actiontype=PhcGeneric&start=0&limit=999'
	}),
	reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['Description', 'RowId']),
	baseParams:{PhcGeName:''}
});


/*
 * 剂型ComboBox
 */
var PhcFormStore = new Ext.data.Store({
	proxy : new Ext.data.HttpProxy({
		url : 'dhcstm.drugutil.csp?actiontype=PhcForm&start=0&limit=999'
	}),
	reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['Description', 'RowId']),
	baseParams:{PHCFDesc:''}
});

/*
 * 用法ComboBox
 */
var PhcInStore = new Ext.data.Store({
	proxy : new Ext.data.HttpProxy({
		url : 'dhcstm.drugutil.csp?actiontype=PHCInstruc&start=0&limit=999'
	}),
	reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['Description', 'RowId']),
	baseParams:{PHCInDesc:''}
});

/*
 * 频次ComboBox
 */
var PhcFreqStore = new Ext.data.Store({
	proxy : new Ext.data.HttpProxy({
		url : 'dhcstm.drugutil.csp?actiontype=PHCFreq&start=0&limit=999'
	}),
	reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['Description', 'RowId']),
	baseParams:{PhcFrDesc:''}
});

/*
 * 疗程ComboBox
 */
var PhcDurationStore = new Ext.data.Store({
	proxy : new Ext.data.HttpProxy({
		url : 'dhcstm.drugutil.csp?actiontype=PhcDuration&start=0&limit=999'
	}),
	reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['Description', 'RowId']),
	baseParams:{PhcDuDesc:''}
});

/*
 * 医保类别ComboBox
 */
var OfficeCodeStore = new Ext.data.Store({
			proxy : new Ext.data.HttpProxy({
						url : 'dhcstm.drugutil.csp?actiontype=GetInsuCat'
					}),
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['Description', 'RowId'])
		});


/*
 * 批准文号ComboBox
 */
var INFORemarkStore = new Ext.data.Store({
			proxy : new Ext.data.HttpProxy({
						url : 'dhcstm.drugutil.csp?actiontype=OfficeCode&Type=Gp'
					}),
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['Description', 'RowId'])
		});

/*
 * 处方类别ComboBox
 */
var INFOOTCStore = new Ext.data.Store({
			proxy : new Ext.data.HttpProxy({
						url : 'dhcstm.drugutil.csp?actiontype=OfficeCode&Type=Gpp'
					}),
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['Description', 'RowId'])
		});

/*
 * 招标级别ComboBox
 */
var INFOPBLevelStore = new Ext.data.Store({
			proxy : new Ext.data.HttpProxy({
						url : 'dhcstm.drugutil.csp?actiontype=GetPBLevel'
					}),
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['Description', 'RowId'])
		});

/*
 * 质量层次
 */
var INFOQualityLevelStore = new Ext.data.Store({
			proxy : new Ext.data.HttpProxy({
						url : 'dhcstm.drugutil.csp?actiontype=GetQualityLevel'
					}),
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['Description', 'RowId'])
		});

/*
 * 管制分类ComboBox
 */
var PhcPoisonStore = new Ext.data.Store({
			proxy : new Ext.data.HttpProxy({
						url : 'dhcstm.drugutil.csp?actiontype=PhcPoison'
					}),
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['Description', 'RowId'])
		});


/*
 * 费用大类ComboBox
 */
var ArcBillGrpStore = new Ext.data.Store({
			proxy : new Ext.data.HttpProxy({
						url : 'dhcstm.drugutil.csp?actiontype=ArcBillGrp&Desc='
					}),
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['Description', 'RowId'])
		});

/*
 * 费用子类ComboBox
 */
var ArcBillSubStore = new Ext.data.Store({
			proxy : new Ext.data.HttpProxy({
						url : 'dhcstm.drugutil.csp?actiontype=ArcBillSub'
					}),
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['Description', 'RowId']),
			baseParams:{ARCBGRowId:""}
		});

/*
 * 医嘱大类ComboBox
 */
var OrderCategoryStore = new Ext.data.Store({
			proxy : new Ext.data.HttpProxy({
						url : 'dhcstm.drugutil.csp?actiontype=OrderCategory&StkType='+App_StkTypeCode
					}),
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['Description', 'RowId'])
		});
		
/*
 * 医嘱子类ComboBox
 */
var ArcItemCatStore = new Ext.data.Store({
			proxy : new Ext.data.HttpProxy({
						url : 'dhcstm.drugutil.csp?actiontype=ArcItemCat&StkType='+App_StkTypeCode
					}),
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['Description', 'RowId'])
			//queryMode:'local',
			//autoLoad:'false'
		});

/*
 * 医嘱优先级ComboBox
 */
var OECPriorityStore = new Ext.data.Store({
			proxy : new Ext.data.HttpProxy({
						url : 'dhcstm.drugutil.csp?actiontype=OECPriority'
					}),
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['Description', 'RowId'])
		});

/*
 * 定价类型ComboBox
 */
var MarkTypeStore = new Ext.data.Store({
			proxy : new Ext.data.HttpProxy({
						url : 'dhcstm.drugutil.csp?actiontype=MarkType'
					}),
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['Description', 'RowId'])
		});
/*
 * 招标名称ComboBox
 */
var PublicBiddingListStore = new Ext.data.Store({
			proxy : new Ext.data.HttpProxy({
						url : 'dhcstm.drugutil.csp?actiontype=PublicBiddingList'
					}),
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['Description', 'RowId'])
		});

/*
 * 帐薄分类ComboBox
 */
var BookCatStore = new Ext.data.Store({
			proxy : new Ext.data.HttpProxy({
						url : 'dhcstm.drugutil.csp?actiontype=BookCat'
					}),
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['Description', 'RowId'])
		});

/*
 * 库存项屏蔽原因
 */
var ItmNotUseReasonStore = new Ext.data.Store({
			proxy : new Ext.data.HttpProxy({
						url : 'dhcstm.drugutil.csp?actiontype=GetItmNotUseReason'
					}),
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['Description', 'RowId'])
		});
		
/*
 * 货位码ComboBox
 */
var StkBinStore = new Ext.data.Store({
	proxy : new Ext.data.HttpProxy({
		url : 'dhcstm.drugutil.csp?actiontype=GetStkBin&Desc=&start=0&limit=999'
	}),
	reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['Description', 'RowId'])
});

/*
 * 科室货位码ComboBox
 */
var LocStkBinStore = new Ext.data.Store({
	proxy : new Ext.data.HttpProxy({
		url : 'dhcstm.drugutil.csp?actiontype=GetLocStkBin'
	}),
	reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['Description', 'RowId']),
	baseParams:{LocId:'',Desc:''}
});

/*
 * 子分类ComboBox
 */
var TarSubCateStore = new Ext.data.Store({
			proxy : new Ext.data.HttpProxy({
						url : 'dhcstm.drugutil.csp?actiontype=GetTarSubCate&Desc='
					}),
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['Description', 'RowId'])
		});

/*
 * 会计子分类ComboBox
 */
var TarAcctCateStore = new Ext.data.Store({
			proxy : new Ext.data.HttpProxy({
						url : 'dhcstm.drugutil.csp?actiontype=GetTarAcctCate&Desc='
					}),
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['Description', 'RowId'])
		});
		
/*
 * 住院子分类ComboBox
 */
var TarInpatCateStore = new Ext.data.Store({
			proxy : new Ext.data.HttpProxy({
						url : 'dhcstm.drugutil.csp?actiontype=GetTarInpatCate&Desc='
					}),
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['Description', 'RowId'])
		});
		
/*
 * 病历首页子分类ComboBox
 */
var TarMRCateStore = new Ext.data.Store({
			proxy : new Ext.data.HttpProxy({
						url : 'dhcstm.drugutil.csp?actiontype=GetTarMRCate&Desc='
					}),
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['Description', 'RowId'])
		});
		
/*
 * 核算子分类ComboBox
 */
var TarEMCCateStore = new Ext.data.Store({
			proxy : new Ext.data.HttpProxy({
						url : 'dhcstm.drugutil.csp?actiontype=GetTarEMCCate&Desc='
					}),
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['Description', 'RowId'])
		});

/*
 * 门诊子分类ComboBox
 */
var TarOutpatCateStore = new Ext.data.Store({
			proxy : new Ext.data.HttpProxy({
						url : 'dhcstm.drugutil.csp?actiontype=GetTarOutpatCate&Desc='
					}),
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['Description', 'RowId'])
		});
/*
 * 收费标志类型的ComboBox
 */
var INFOChargeTypeFlagStore = new Ext.data.Store({
			proxy : new Ext.data.HttpProxy({
						url : 'dhcstm.drugutil.csp?actiontype=ChargeType'
					}),
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['Description', 'RowId'])
		});
		
/*
 * 新病案首页ComboBox
 */
var TarNewMRCateStore = new Ext.data.Store({
			proxy : new Ext.data.HttpProxy({
						url : 'dhcstm.drugutil.csp?actiontype=GetTarNewMRCate&Desc='
					}),
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['Description', 'RowId'])
		});
/*
 * 器械分类
 */
var MedEqptCatStore = new Ext.data.Store({
			proxy : new Ext.data.HttpProxy({
						url : 'dhcstm.drugutil.csp?actiontype=GetMedEqptCat'
					}),
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['Description', 'RowId'])
		});

//产地
var StoriginStore = new Ext.data.Store({
	proxy : new Ext.data.HttpProxy({
				url : 'dhcstm.drugutil.csp?actiontype=GetOrigin&start=0&limit=999'
			}),
	reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['Description', 'RowId'])
});
//灭菌分类
var SCategoryStore = new Ext.data.Store({
			proxy : new Ext.data.HttpProxy({
						url : 'dhcstm.drugutil.csp?actiontype=Catequery'
					}),
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['Desc', 'RowId'])
		});
/*
 * 监管级别
 */
var SupervisionStore = new Ext.data.SimpleStore({
	fields : ['RowId', 'Description'],
	data : [['I', 'I'], ['II', 'II'], ['III', 'III'], ['IV', 'IV'], ['V', 'V']]
});

/*
 * 类组归类,独立出来
 */
var SCGSetStore = new Ext.data.SimpleStore({
	fields : ['RowId', 'Description'],
	data : [['MM', '医用材料'], ['MO', '后勤材料'], ['MR', '试剂'], ['MF', '固定资产']]
});
/*
 * 风险类别
 */
var RiskCategoryStore = new Ext.data.SimpleStore({
	fields : ['RowId', 'Description'],
	data : [['I', 'I'], ['II', 'II'], ['III', 'III']]
})
/*
 * 耗材级别
 */
var ConsumableLevelStore = new Ext.data.SimpleStore({
	fields : ['RowId', 'Description'],
	data : [['I', 'I'], ['II', 'II'], ['III', 'III']]
})