/**
 * ����: ��ѯģ�鹫�����
 * ����: pushuangcai
 * ����: 2022-05-23
 */

var QUE_FORM = {
    ToggleBtnId: 'queBtnToggle',            // ���ఴťdomԪ��id
    FormDomId: 'con-form',                  // ��ѯ�����domԪ��id
    FormToggleDomId: 'con-form-toggle',     // ���������domԪ��id    
    /**
     * ��ʼ��������ѯ���
     * @params {object} _opts 
     * @params {string} _opts.btnDomId csp�ж���ĸ��ఴťid
     * @params {string} _opts.formDomId csp�ж���Ĳ�ѯ��id
     * @params {string} _opts.formToggleDomId csp�ж���ġ����ࡱ��ѯ��id
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
        /* ��ʼ�����ఴť */
        this.InitToggleButton();
        
        var that = this;
        /* ͨ��csp�ж����[data-pha]����ȥ������Ҫ��ʼ������� */
        $('#'+ this.FormDomId +' [data-pha], #'+ this.FormToggleDomId +' [data-pha]').each(function () {
            var _id = this.id;
            if (that.Components[_id]){
                that.Components[_id](_id);
            }
        });
        PHA.SetRequired($('#'+ this.FormDomId +' [data-pha]'));
    },
    /**
     * ��ȡ����������д���������������Է�©����
     * ����������Զ�������������õ���Щ�����ڽ���js���ٴ���
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
        /* �ϲ���ͨ������������� */ 
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
     * ��ʼ����������������ť
     */
    InitToggleButton: function(){
        var that = this;
        PHA.ToggleButton(this.ToggleBtnId, {
            buttonTextArr: ['����', '����'],
            selectedText: '����',
            onClick: function(oldText, newText){
                if (oldText === '����'){
                    //$("#"+ that.ToggleBtnId).popover('show');  // ������bug ����������������ܽ��ʾ��ʱ����޷��ֶ�������
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
     * ������ѯ������塣
     * ע�⣺���ﶨ������ȡֵ���ǹ̶��ģ�ֻ��Ϊ�˼��ٴ�������
     * ���硰locId��������רָ��ǰ��¼�İ�ȫ��Ȩ�޿��ҡ�
     * ����������ӡ����п��ҡ������򣬿��ڽ���js����������ڴ˴��������������ķ����� 
     */
    Components: {
        hosp: function(id){
            PHA.ComboBox(id, {
                placeholder: 'Ժ��...',
                url: PHA_STORE.CTHospital().url
            }); 
        },
        locId: function(id){
            PHA_UX.ComboBox.Loc(id);
        },
        phaLocId: function(id){
            PHA.ComboBox(id, {
                placeholder: 'ҩ������...',
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
                placeholder: 'ҩƷ����...',
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
                placeholder: 'ҩƷ...',
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
                placeholder: '����...',
                url: PHA_STORE.PHCForm().url,
            });
        },
        arcItmCat: function(id){
            PHA.ComboBox(id, {
                placeholder: 'ҽ������...',
                url: PHA_STORE.ARCItemCat().url 
            }); 
        },
        stkbin: function(id){
            PHA.ComboBox(id, {
                placeholder: '��λ...',
                hasDownArrow: false,
                url: PHA_IN_STORE.StkBinComb(PHA_COM.VAR.locId).url
            });
        },
        generic: function(id){
            var _opts = PHA_STORE.PHCGeneric();
            _opts.width = 160;
            _opts.placeholder = "����ͨ����...";
            PHA.ComboGrid(id, _opts);
        },
        genePHCCat: function(id){
            PHA.TriggerBox(id, {
                width: 160,
                placeholder: 'ҩѧ����...',
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
                placeholder: '���ڱ�־...',
                valueField: 'id',
                textField: 'text',
                data: [
                    {text: $g("����"), id: "����"},
                    {text: $g("����"), id: "����"},
                    {text: $g("����"), id: "����"}
                ]   
            });
        },
        origin: function(id){
            PHA.ComboBox(id, {
                placeholder: '����...',
                url: PHA_STORE.DHCSTOrigin().url    
            });
        },
        phcInstruc: function(id){
            PHA.ComboBox(id, {
                placeholder: '�÷�...',
                url: PHA_STORE.PHCInstruc().url 
            });
        },
        departmentGroup: function(id){
            PHA.ComboBox(id, {
                placeholder: '������...',
                url: PHA_STORE.RBCDepartmentGroup().url
            }); 
        }
    }
}


 