/**
 * 名称: 查询模块公共组件
 * 作者: pushuangcai
 * 日期: 2022-05-23
 */

var QUE_FORM = {
    ToggleBtnId: 'queBtnToggle',            // 更多按钮dom元素id
    FormDomId: 'con-form',                  // 查询组件表单dom元素id
    FormToggleDomId: 'con-form-toggle',     // 更多组件表单dom元素id    
    /**
     * 初始化公共查询组件
     * @params {object} _opts 
     * @params {string} _opts.btnDomId csp中定义的更多按钮id
     * @params {string} _opts.formDomId csp中定义的查询表单id
     * @params {string} _opts.formToggleDomId csp中定义的“更多”查询表单id
     */
    InitComponents: function(_opts){
        if (_opts){
            if (_opts.btnDomId){
                this.ToggleBtnId = btnDomId;
            }
            if (_opts.formDomId){
                this.FormDomId = formDomId;
            }
            if (_opts.formToggleDomId){
                this.FormToggleDomId = formToggleDomId;
            }
        }
        /* 初始化更多按钮 */
        this.InitToggleButton();
        
        var that = this;
        /* 通过csp中定义的[data-pha]属性去检索需要初始化的组件 */
        $('#'+ this.FormDomId +' [data-pha], #'+ this.FormToggleDomId +' [data-pha]').each(function () {
            var _id = this.id;
            if (that.Components[_id]){
                that.Components[_id](_id);
            }
        });
        PHA.SetRequired($('#'+ this.FormDomId +' [data-pha]'));
    },
    /**
     * 获取公共参数，写到公共方法里面以防漏掉。
     * 如果界面有自定义组件，可以拿到这些参数在界面js里再处理。
     */
    GetFormData: function(){
        var formDataArr = PHA.DomData("#"+ this.FormDomId, {
            doType: 'query',
            retType: 'Json'
        }); 
        if (formDataArr.length === 0) {
            return null;
        }       
        var toggleFormDataArr = PHA.DomData("#"+ this.FormToggleDomId, {
            doType: 'query',
            retType: 'Json'
        }); 
        if ((formDataArr.length === 0) && (toggleFormDataArr.length === 0)) {
            return null;
        }
        /* 合并普通条件与更多条件 */ 
        var formData = $.extend({}, formDataArr[0], toggleFormDataArr[0]);
        var $inciDescBox = $('#inciDesc');
        if ($inciDescBox.length > 0){
            formData.inciDesc = $inciDescBox.combobox('getText');   
        }
        var $stkbinBox = $('#stkbin');
        if ($stkbinBox.length > 0){
            formData.stkbin = $stkbinBox.combobox('getText');   
        }       
        return formData;
    },
    ClearFormData: function(){
        var formDataArr = PHA.DomData("#"+ this.FormDomId, {
            doType: 'clear'
        });
        var formDataArr = PHA.DomData("#"+ this.FormToggleDomId, {
            doType: 'clear'
        }); 
        $HUI.checkbox('#useFlag').check();  
    },
    /**
     * 初始化更多条件触发按钮
     */
    InitToggleButton: function(){
        var that = this;
        PHA.ToggleButton(this.ToggleBtnId, {
            buttonTextArr: ['更多', '隐藏'],
            selectedText: '更多',
            onClick: function(oldText, newText){
                if (oldText === '更多'){
                    //$("#"+ that.ToggleBtnId).popover('show');  // 这里有bug 当界面上有两个泡芙提示的时候就无法手动弹出了
                } else {
                    //$('#'+ that.ToggleBtnId).popover('hide');
                }
            }   
        }); 

        $("#"+ this.ToggleBtnId).popover({
            trigger: 'click',   
            placement: 'auto',
            content: 'content',
            dismissible: false,
            width: 1130,
            padding: false,
            url: '#'+ this.FormToggleDomId
        });
    },
    /** 
     * 公共查询组件定义。
     * 注意：这里定义的组件取值都是固定的，只是为了减少代码量。
     * 比如“locId”，这里专指当前登录的安全组权限科室。
     * 界面如需添加“所有科室”下拉框，可在界面js单独定义或在此处新增其他命名的方法。 
     */
    Components: {
        hosp: function(id){
            PHA.ComboBox(id, {
                placeholder: '院区...',
                url: PHA_STORE.CTHospital().url
            }); 
        },
        locId: function(id){
            PHA_UX.ComboBox.Loc(id);
        },
        phaLocId: function(id){
            PHA.ComboBox(id, {
                placeholder: '药房科室...',
                url: PHA_STORE.Pharmacy().url
            }); 
        },
        scg: function(id){
            PHA_UX.ComboBox.StkCatGrp(id, {
                multiple: true,
                rowStyle: 'checkbox',
                qParams: {
                    LocId: PHA_UX.Get('locId', session['LOGON.CTLOCID']),
                    UserId: session['LOGON.USERID']
                }
            }); 
        },
        stkCat: function(id){
            PHA_UX.ComboBox.StkCat(id, {
                multiple: true,
                rowStyle: 'checkbox',
                qParams: {
                    CatGrpId: PHA_UX.Get('scg'),    
                    HospId: session['LOGON.HOSPID']
                }   
            }); 
        },
        vendor: function(id){
            PHA_UX.ComboBox.Vendor(id);
        },
        manf: function(id){
            PHA_UX.ComboBox.Manf(id);   
        },
        inciDesc: function(id){
            PHA_UX.ComboBox.INCItm(id, {
                hasDownArrow: false,
                placeholder: '药品别名...',
                keyHandler: {
					down : $.fn.combobox.defaults.keyHandler.down,
					enter: function () {
						$('#' + id).combobox('hidePanel');
                        if (Query) { Query(); }
					},
					up: $.fn.combobox.defaults.keyHandler.up,
					left: $.fn.combobox.defaults.keyHandler.left,
					right: $.fn.combobox.defaults.keyHandler.right,
					query : $.fn.combobox.defaults.keyHandler.query,
				}
            }); 
        },
        inci: function(id){
            PHA_UX.ComboGrid.INCItm(id, {
                width: 160, 
                panelWidth: 600,
                placeholder: '药品...',
                qParams: {
                    pJsonStr: {
                        scgId: PHA_UX.Get('scg'),
                        stkType: 'G',
                        userId: session['LOGON.USERID'],
                        locId: PHA_UX.Get('locId'),
                    }
                }
            });
        },
        poisonIdStr: function(id){
            PHA_UX.ComboBox.Poison(id, {
                multiple: true,
                rowStyle: 'checkbox'
            }); 
        },
        phcForm: function(id){
            PHA.ComboBox(id, {
                placeholder: '剂型...',
                url: PHA_STORE.PHCForm().url,
            });
        },
        arcItmCat: function(id){
            PHA.ComboBox(id, {
                placeholder: '医嘱子类...',
                url: PHA_STORE.ARCItemCat().url 
            }); 
        },
        stkbin: function(id){
            PHA.ComboBox(id, {
                placeholder: '货位...',
                hasDownArrow: false,
                url: PHA_IN_STORE.StkBinComb(PHA_COM.VAR.locId).url
            });
        },
        generic: function(id){
            var _opts = PHA_STORE.PHCGeneric();
            _opts.width = 160;
            _opts.placeholder = "处方通用名...";
            PHA.ComboGrid(id, _opts);
        },
        genePHCCat: function(id){
            PHA.TriggerBox(id, {
                width: 160,
                placeholder: '药学分类...',
                handler: function (data) {
                    PHA_UX.DHCPHCCat("genePHCCat", {}, function (data) {
                        $("#genePHCCat").triggerbox("setValue", data.phcCatDescAll);
                        $("#genePHCCat").triggerbox("setValueId", data.phcCatId);
                    });
                }
            });
        },  
        importFlag: function(id){
            PHA.ComboBox(id, {
                placeholder: '进口标志...',
                valueField: 'id',
                textField: 'text',
                data: [
                    {text: $g("国产"), id: "国产"},
                    {text: $g("进口"), id: "进口"},
                    {text: $g("合资"), id: "合资"}
                ]   
            });
        },
        origin: function(id){
            PHA.ComboBox(id, {
                placeholder: '产地...',
                url: PHA_STORE.DHCSTOrigin().url    
            });
        },
        phcInstruc: function(id){
            PHA.ComboBox(id, {
                placeholder: '用法...',
                url: PHA_STORE.PHCInstruc().url 
            });
        },
        departmentGroup: function(id){
            PHA.ComboBox(id, {
                placeholder: '部门组...',
                url: PHA_STORE.RBCDepartmentGroup().url
            }); 
        }
    }
}


 