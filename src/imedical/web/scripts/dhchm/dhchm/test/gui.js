function InitViewportMain(){
	var obj = new Object();
	obj.ElementNum=1/3
	obj.InputInfo="��¼��..."
	obj.ButtonT = new Ext.Button({
		id : 'ButtonT'
		,text : '���form'
});
var QuestionPanel = new Ext.form.FormPanel({
        title: 'Test',
        frame: true,
        autoScroll: true,
        id: 'PQ24||43',
        items: [],
        closable:true
});

var TitlePanel = new Ext.form.FieldSet({
        title: '<h1><BIG><BIG>��������ʷ</BIG></BIG>',
       frame: true,
        autoHeight: true,
        layout: 'column',
        //layout:'table',
        collapsed: false,
        collapsible: true,
        collapseFirst: true,
        id: 'Q24||43^2||5'
    });
var DetailFieldSets = new Ext.form.FieldSet({
                        title: '<BIG>��Ѫѹ����ʷ</BIG>',
                        layout: 'column',
                        id: 'FSQ24||43^2||5^169',
                        columnWidth: 1,
                        border: false,
                        frame: true,
                        autoHeight: true,
                        //collapsed:false,
                        //collapsible:true,
                        collapseFirst: true
                    });
Field = new Ext.form.Checkbox({
                                id: 'Q24||43^24||43||8732',
                                boxLabel:'����',
                                checked: false,
                                hideLabel: true,
                                name:'Q24||43^2||5^169',
                                inputValue:'24||43||8732'
                            //,fieldLabel :SelectDesc
                            //,labelSeparator:''
                            });
var FieldPanel = new Ext.Panel({
                            layout: 'form',
                            items: Field,
                            id: 'PQ24||43^2||5^169^24||43||8732',
                            autoHeight: true,
                            columnWidth: obj.ElementNum,
                            style: ' padding:0px 0px  0px  10px;'
                        })
                        DetailFieldSets.add(FieldPanel);
Field = new Ext.form.Checkbox({
                                id: 'Q24||43^24||43||8733',
                                boxLabel:'ĸ��',
                                checked: false,
                                hideLabel: true,
                                name:'Q24||43^2||5^169',
                                inputValue:'24||43||8733'
                            //,fieldLabel :SelectDesc
                            //,labelSeparator:''
                            });
var FieldPanel = new Ext.Panel({
                            layout: 'form',
                            items: Field,
                            id: 'PQ24||43^2||5^169^24||43||8733',
                            autoHeight: true,
                            columnWidth: obj.ElementNum,
                            style: ' padding:0px 0px  0px  10px;'
                        })
                        DetailFieldSets.add(FieldPanel);
Field = new Ext.form.Checkbox({
                                id: 'Q24||43^24||43||8734',
                                boxLabel:'�ֵܽ���',
                                checked: false,
                                hideLabel: true,
                                name:'Q24||43^2||5^169',
                                inputValue:'24||43||8734'
                            //,fieldLabel :SelectDesc
                            //,labelSeparator:''
                            });
var FieldPanel = new Ext.Panel({
                            layout: 'form',
                            items: Field,
                            id: 'PQ24||43^2||5^169^24||43||8734',
                            autoHeight: true,
                            columnWidth: obj.ElementNum,
                            style: ' padding:0px 0px  0px  10px;'
                        })
                        DetailFieldSets.add(FieldPanel);
Field = new Ext.form.Checkbox({
                                id: 'Q24||43^24||43||8735',
                                boxLabel:'��Ů',
                                checked: false,
                                hideLabel: true,
                                name:'Q24||43^2||5^169',
                                inputValue:'24||43||8735'
                            //,fieldLabel :SelectDesc
                            //,labelSeparator:''
                            });
var FieldPanel = new Ext.Panel({
                            layout: 'form',
                            items: Field,
                            id: 'PQ24||43^2||5^169^24||43||8735',
                            autoHeight: true,
                            columnWidth: obj.ElementNum,
                            style: ' padding:0px 0px  0px  10px;'
                        })
                        DetailFieldSets.add(FieldPanel);
                    TitlePanel.add(DetailFieldSets);
var DetailFieldSets = new Ext.form.FieldSet({
                        title: '<BIG>���򲡼���ʷ</BIG>',
                        layout: 'column',
                        id: 'FSQ24||43^2||5^170',
                        columnWidth: 1,
                        border: false,
                        frame: true,
                        autoHeight: true,
                        //collapsed:false,
                        //collapsible:true,
                        collapseFirst: true
                    });
Field = new Ext.form.Checkbox({
                                id: 'Q24||43^24||43||8736',
                                boxLabel:'����',
                                checked: false,
                                hideLabel: true,
                                name:'Q24||43^2||5^170',
                                inputValue:'24||43||8736'
                            //,fieldLabel :SelectDesc
                            //,labelSeparator:''
                            });
var FieldPanel = new Ext.Panel({
                            layout: 'form',
                            items: Field,
                            id: 'PQ24||43^2||5^170^24||43||8736',
                            autoHeight: true,
                            columnWidth: obj.ElementNum,
                            style: ' padding:0px 0px  0px  10px;'
                        })
                        DetailFieldSets.add(FieldPanel);
Field = new Ext.form.Checkbox({
                                id: 'Q24||43^24||43||8737',
                                boxLabel:'ĸ��',
                                checked: false,
                                hideLabel: true,
                                name:'Q24||43^2||5^170',
                                inputValue:'24||43||8737'
                            //,fieldLabel :SelectDesc
                            //,labelSeparator:''
                            });
var FieldPanel = new Ext.Panel({
                            layout: 'form',
                            items: Field,
                            id: 'PQ24||43^2||5^170^24||43||8737',
                            autoHeight: true,
                            columnWidth: obj.ElementNum,
                            style: ' padding:0px 0px  0px  10px;'
                        })
                        DetailFieldSets.add(FieldPanel);
Field = new Ext.form.Checkbox({
                                id: 'Q24||43^24||43||8738',
                                boxLabel:'�ֵܽ���',
                                checked: false,
                                hideLabel: true,
                                name:'Q24||43^2||5^170',
                                inputValue:'24||43||8738'
                            //,fieldLabel :SelectDesc
                            //,labelSeparator:''
                            });
var FieldPanel = new Ext.Panel({
                            layout: 'form',
                            items: Field,
                            id: 'PQ24||43^2||5^170^24||43||8738',
                            autoHeight: true,
                            columnWidth: obj.ElementNum,
                            style: ' padding:0px 0px  0px  10px;'
                        })
                        DetailFieldSets.add(FieldPanel);
Field = new Ext.form.Checkbox({
                                id: 'Q24||43^24||43||8739',
                                boxLabel:'��Ů',
                                checked: false,
                                hideLabel: true,
                                name:'Q24||43^2||5^170',
                                inputValue:'24||43||8739'
                            //,fieldLabel :SelectDesc
                            //,labelSeparator:''
                            });
var FieldPanel = new Ext.Panel({
                            layout: 'form',
                            items: Field,
                            id: 'PQ24||43^2||5^170^24||43||8739',
                            autoHeight: true,
                            columnWidth: obj.ElementNum,
                            style: ' padding:0px 0px  0px  10px;'
                        })
                        DetailFieldSets.add(FieldPanel);
                    TitlePanel.add(DetailFieldSets);
var DetailFieldSets = new Ext.form.FieldSet({
                        title: '<BIG>���򲡼���ʷ</BIG>',
                        layout: 'column',
                        id: 'FSQ24||43^2||5^170',
                        columnWidth: 1,
                        border: false,
                        frame: true,
                        autoHeight: true,
                        //collapsed:false,
                        //collapsible:true,
                        collapseFirst: true
                    });
Field = new Ext.form.Checkbox({
                                id: 'Q24||43^24||43||8736',
                                boxLabel:'����',
                                checked: false,
                                hideLabel: true,
                                name:'Q24||43^2||5^170',
                                inputValue:'24||43||8736'
                            //,fieldLabel :SelectDesc
                            //,labelSeparator:''
                            });
var FieldPanel = new Ext.Panel({
                            layout: 'form',
                            items: Field,
                            id: 'PQ24||43^2||5^170^24||43||8736',
                            autoHeight: true,
                            columnWidth: obj.ElementNum,
                            style: ' padding:0px 0px  0px  10px;'
                        })
                        DetailFieldSets.add(FieldPanel);
Field = new Ext.form.Checkbox({
                                id: 'Q24||43^24||43||8737',
                                boxLabel:'ĸ��',
                                checked: false,
                                hideLabel: true,
                                name:'Q24||43^2||5^170',
                                inputValue:'24||43||8737'
                            //,fieldLabel :SelectDesc
                            //,labelSeparator:''
                            });
var FieldPanel = new Ext.Panel({
                            layout: 'form',
                            items: Field,
                            id: 'PQ24||43^2||5^170^24||43||8737',
                            autoHeight: true,
                            columnWidth: obj.ElementNum,
                            style: ' padding:0px 0px  0px  10px;'
                        })
                        DetailFieldSets.add(FieldPanel);
Field = new Ext.form.Checkbox({
                                id: 'Q24||43^24||43||8738',
                                boxLabel:'�ֵܽ���',
                                checked: false,
                                hideLabel: true,
                                name:'Q24||43^2||5^170',
                                inputValue:'24||43||8738'
                            //,fieldLabel :SelectDesc
                            //,labelSeparator:''
                            });
var FieldPanel = new Ext.Panel({
                            layout: 'form',
                            items: Field,
                            id: 'PQ24||43^2||5^170^24||43||8738',
                            autoHeight: true,
                            columnWidth: obj.ElementNum,
                            style: ' padding:0px 0px  0px  10px;'
                        })
                        DetailFieldSets.add(FieldPanel);
Field = new Ext.form.Checkbox({
                                id: 'Q24||43^24||43||8739',
                                boxLabel:'��Ů',
                                checked: false,
                                hideLabel: true,
                                name:'Q24||43^2||5^170',
                                inputValue:'24||43||8739'
                            //,fieldLabel :SelectDesc
                            //,labelSeparator:''
                            });
var FieldPanel = new Ext.Panel({
                            layout: 'form',
                            items: Field,
                            id: 'PQ24||43^2||5^170^24||43||8739',
                            autoHeight: true,
                            columnWidth: obj.ElementNum,
                            style: ' padding:0px 0px  0px  10px;'
                        })
                        DetailFieldSets.add(FieldPanel);
                    TitlePanel.add(DetailFieldSets);
var DetailFieldSets = new Ext.form.FieldSet({
                        title: '<BIG>���򲡼���ʷ</BIG>',
                        layout: 'column',
                        id: 'FSQ24||43^2||5^170',
                        columnWidth: 1,
                        border: false,
                        frame: true,
                        autoHeight: true,
                        //collapsed:false,
                        //collapsible:true,
                        collapseFirst: true
                    });
Field = new Ext.form.Checkbox({
                                id: 'Q24||43^24||43||8736',
                                boxLabel:'����',
                                checked: false,
                                hideLabel: true,
                                name:'Q24||43^2||5^170',
                                inputValue:'24||43||8736'
                            //,fieldLabel :SelectDesc
                            //,labelSeparator:''
                            });
var FieldPanel = new Ext.Panel({
                            layout: 'form',
                            items: Field,
                            id: 'PQ24||43^2||5^170^24||43||8736',
                            autoHeight: true,
                            columnWidth: obj.ElementNum,
                            style: ' padding:0px 0px  0px  10px;'
                        })
                        DetailFieldSets.add(FieldPanel);
Field = new Ext.form.Checkbox({
                                id: 'Q24||43^24||43||8737',
                                boxLabel:'ĸ��',
                                checked: false,
                                hideLabel: true,
                                name:'Q24||43^2||5^170',
                                inputValue:'24||43||8737'
                            //,fieldLabel :SelectDesc
                            //,labelSeparator:''
                            });
var FieldPanel = new Ext.Panel({
                            layout: 'form',
                            items: Field,
                            id: 'PQ24||43^2||5^170^24||43||8737',
                            autoHeight: true,
                            columnWidth: obj.ElementNum,
                            style: ' padding:0px 0px  0px  10px;'
                        })
                        DetailFieldSets.add(FieldPanel);
Field = new Ext.form.Checkbox({
                                id: 'Q24||43^24||43||8738',
                                boxLabel:'�ֵܽ���',
                                checked: false,
                                hideLabel: true,
                                name:'Q24||43^2||5^170',
                                inputValue:'24||43||8738'
                            //,fieldLabel :SelectDesc
                            //,labelSeparator:''
                            });
var FieldPanel = new Ext.Panel({
                            layout: 'form',
                            items: Field,
                            id: 'PQ24||43^2||5^170^24||43||8738',
                            autoHeight: true,
                            columnWidth: obj.ElementNum,
                            style: ' padding:0px 0px  0px  10px;'
                        })
                        DetailFieldSets.add(FieldPanel);
Field = new Ext.form.Checkbox({
                                id: 'Q24||43^24||43||8739',
                                boxLabel:'��Ů',
                                checked: false,
                                hideLabel: true,
                                name:'Q24||43^2||5^170',
                                inputValue:'24||43||8739'
                            //,fieldLabel :SelectDesc
                            //,labelSeparator:''
                            });
var FieldPanel = new Ext.Panel({
                            layout: 'form',
                            items: Field,
                            id: 'PQ24||43^2||5^170^24||43||8739',
                            autoHeight: true,
                            columnWidth: obj.ElementNum,
                            style: ' padding:0px 0px  0px  10px;'
                        })
                        DetailFieldSets.add(FieldPanel);
                    TitlePanel.add(DetailFieldSets);
var DetailFieldSets = new Ext.form.FieldSet({
                        title: '<BIG>�����м���ʷ</BIG>',
                        layout: 'column',
                        id: 'FSQ24||43^2||5^172',
                        columnWidth: 1,
                        border: false,
                        frame: true,
                        autoHeight: true,
                        //collapsed:false,
                        //collapsible:true,
                        collapseFirst: true
                    });
Field = new Ext.form.Checkbox({
                                id: 'Q24||43^24||43||8744',
                                boxLabel:'����',
                                checked: false,
                                hideLabel: true,
                                name:'Q24||43^2||5^172',
                                inputValue:'24||43||8744'
                            //,fieldLabel :SelectDesc
                            //,labelSeparator:''
                            });
var FieldPanel = new Ext.Panel({
                            layout: 'form',
                            items: Field,
                            id: 'PQ24||43^2||5^172^24||43||8744',
                            autoHeight: true,
                            columnWidth: obj.ElementNum,
                            style: ' padding:0px 0px  0px  10px;'
                        })
                        DetailFieldSets.add(FieldPanel);
Field = new Ext.form.Checkbox({
                                id: 'Q24||43^24||43||8745',
                                boxLabel:'ĸ��',
                                checked: false,
                                hideLabel: true,
                                name:'Q24||43^2||5^172',
                                inputValue:'24||43||8745'
                            //,fieldLabel :SelectDesc
                            //,labelSeparator:''
                            });
var FieldPanel = new Ext.Panel({
                            layout: 'form',
                            items: Field,
                            id: 'PQ24||43^2||5^172^24||43||8745',
                            autoHeight: true,
                            columnWidth: obj.ElementNum,
                            style: ' padding:0px 0px  0px  10px;'
                        })
                        DetailFieldSets.add(FieldPanel);
Field = new Ext.form.Checkbox({
                                id: 'Q24||43^24||43||8746',
                                boxLabel:'�ֵܽ���',
                                checked: false,
                                hideLabel: true,
                                name:'Q24||43^2||5^172',
                                inputValue:'24||43||8746'
                            //,fieldLabel :SelectDesc
                            //,labelSeparator:''
                            });
var FieldPanel = new Ext.Panel({
                            layout: 'form',
                            items: Field,
                            id: 'PQ24||43^2||5^172^24||43||8746',
                            autoHeight: true,
                            columnWidth: obj.ElementNum,
                            style: ' padding:0px 0px  0px  10px;'
                        })
                        DetailFieldSets.add(FieldPanel);
Field = new Ext.form.Checkbox({
                                id: 'Q24||43^24||43||8747',
                                boxLabel:'��Ů',
                                checked: false,
                                hideLabel: true,
                                name:'Q24||43^2||5^172',
                                inputValue:'24||43||8747'
                            //,fieldLabel :SelectDesc
                            //,labelSeparator:''
                            });
var FieldPanel = new Ext.Panel({
                            layout: 'form',
                            items: Field,
                            id: 'PQ24||43^2||5^172^24||43||8747',
                            autoHeight: true,
                            columnWidth: obj.ElementNum,
                            style: ' padding:0px 0px  0px  10px;'
                        })
                        DetailFieldSets.add(FieldPanel);
                    TitlePanel.add(DetailFieldSets);
var DetailFieldSets = new Ext.form.FieldSet({
                        title: '<BIG>���ּ���ʷ</BIG>',
                        layout: 'column',
                        id: 'FSQ24||43^2||5^173',
                        columnWidth: 1,
                        border: false,
                        frame: true,
                        autoHeight: true,
                        //collapsed:false,
                        //collapsible:true,
                        collapseFirst: true
                    });
Field = new Ext.form.Checkbox({
                                id: 'Q24||43^24||43||8748',
                                boxLabel:'����',
                                checked: false,
                                hideLabel: true,
                                name:'Q24||43^2||5^173',
                                inputValue:'24||43||8748'
                            //,fieldLabel :SelectDesc
                            //,labelSeparator:''
                            });
var FieldPanel = new Ext.Panel({
                            layout: 'form',
                            items: Field,
                            id: 'PQ24||43^2||5^173^24||43||8748',
                            autoHeight: true,
                            columnWidth: obj.ElementNum,
                            style: ' padding:0px 0px  0px  10px;'
                        })
                        DetailFieldSets.add(FieldPanel);
Field = new Ext.form.Checkbox({
                                id: 'Q24||43^24||43||8749',
                                boxLabel:'ĸ��',
                                checked: false,
                                hideLabel: true,
                                name:'Q24||43^2||5^173',
                                inputValue:'24||43||8749'
                            //,fieldLabel :SelectDesc
                            //,labelSeparator:''
                            });
var FieldPanel = new Ext.Panel({
                            layout: 'form',
                            items: Field,
                            id: 'PQ24||43^2||5^173^24||43||8749',
                            autoHeight: true,
                            columnWidth: obj.ElementNum,
                            style: ' padding:0px 0px  0px  10px;'
                        })
                        DetailFieldSets.add(FieldPanel);
Field = new Ext.form.Checkbox({
                                id: 'Q24||43^24||43||8750',
                                boxLabel:'�ֵܽ���',
                                checked: false,
                                hideLabel: true,
                                name:'Q24||43^2||5^173',
                                inputValue:'24||43||8750'
                            //,fieldLabel :SelectDesc
                            //,labelSeparator:''
                            });
var FieldPanel = new Ext.Panel({
                            layout: 'form',
                            items: Field,
                            id: 'PQ24||43^2||5^173^24||43||8750',
                            autoHeight: true,
                            columnWidth: obj.ElementNum,
                            style: ' padding:0px 0px  0px  10px;'
                        })
                        DetailFieldSets.add(FieldPanel);
Field = new Ext.form.Checkbox({
                                id: 'Q24||43^24||43||8751',
                                boxLabel:'��Ů',
                                checked: false,
                                hideLabel: true,
                                name:'Q24||43^2||5^173',
                                inputValue:'24||43||8751'
                            //,fieldLabel :SelectDesc
                            //,labelSeparator:''
                            });
var FieldPanel = new Ext.Panel({
                            layout: 'form',
                            items: Field,
                            id: 'PQ24||43^2||5^173^24||43||8751',
                            autoHeight: true,
                            columnWidth: obj.ElementNum,
                            style: ' padding:0px 0px  0px  10px;'
                        })
                        DetailFieldSets.add(FieldPanel);
                    TitlePanel.add(DetailFieldSets);
var DetailFieldSets = new Ext.form.FieldSet({
                        title: '<BIG>��֢����ʷ</BIG>',
                        layout: 'column',
                        id: 'FSQ24||43^2||5^174',
                        columnWidth: 1,
                        border: false,
                        frame: true,
                        autoHeight: true,
                        //collapsed:false,
                        //collapsible:true,
                        collapseFirst: true
                    });
Field = new Ext.form.Checkbox({
                                id: 'Q24||43^24||43||8752',
                                boxLabel:'����',
                                checked: false,
                                hideLabel: true,
                                name:'Q24||43^2||5^174',
                                inputValue:'24||43||8752'
                            //,fieldLabel :SelectDesc
                            //,labelSeparator:''
                            });
var FieldPanel = new Ext.Panel({
                            layout: 'form',
                            items: Field,
                            id: 'PQ24||43^2||5^174^24||43||8752',
                            autoHeight: true,
                            columnWidth: obj.ElementNum,
                            style: ' padding:0px 0px  0px  10px;'
                        })
                        DetailFieldSets.add(FieldPanel);
Field = new Ext.form.Checkbox({
                                id: 'Q24||43^24||43||8753',
                                boxLabel:'ĸ��',
                                checked: false,
                                hideLabel: true,
                                name:'Q24||43^2||5^174',
                                inputValue:'24||43||8753'
                            //,fieldLabel :SelectDesc
                            //,labelSeparator:''
                            });
var FieldPanel = new Ext.Panel({
                            layout: 'form',
                            items: Field,
                            id: 'PQ24||43^2||5^174^24||43||8753',
                            autoHeight: true,
                            columnWidth: obj.ElementNum,
                            style: ' padding:0px 0px  0px  10px;'
                        })
                        DetailFieldSets.add(FieldPanel);
Field = new Ext.form.Checkbox({
                                id: 'Q24||43^24||43||8754',
                                boxLabel:'�ֵܽ���',
                                checked: false,
                                hideLabel: true,
                                name:'Q24||43^2||5^174',
                                inputValue:'24||43||8754'
                            //,fieldLabel :SelectDesc
                            //,labelSeparator:''
                            });
var FieldPanel = new Ext.Panel({
                            layout: 'form',
                            items: Field,
                            id: 'PQ24||43^2||5^174^24||43||8754',
                            autoHeight: true,
                            columnWidth: obj.ElementNum,
                            style: ' padding:0px 0px  0px  10px;'
                        })
                        DetailFieldSets.add(FieldPanel);
Field = new Ext.form.Checkbox({
                                id: 'Q24||43^24||43||8755',
                                boxLabel:'��Ů',
                                checked: false,
                                hideLabel: true,
                                name:'Q24||43^2||5^174',
                                inputValue:'24||43||8755'
                            //,fieldLabel :SelectDesc
                            //,labelSeparator:''
                            });
var FieldPanel = new Ext.Panel({
                            layout: 'form',
                            items: Field,
                            id: 'PQ24||43^2||5^174^24||43||8755',
                            autoHeight: true,
                            columnWidth: obj.ElementNum,
                            style: ' padding:0px 0px  0px  10px;'
                        })
                        DetailFieldSets.add(FieldPanel);
                    TitlePanel.add(DetailFieldSets);
QuestionPanel.add(TitlePanel);
var TitlePanel = new Ext.form.FieldSet({
        title: '<h1><BIG><BIG>������ʷ������֪���������</BIG></BIG>',
       frame: true,
        autoHeight: true,
        layout: 'column',
        //layout:'table',
        collapsed: false,
        collapsible: true,
        collapseFirst: true,
        id: 'Q24||43^2||6'
    });
var DetailFieldSets = new Ext.form.FieldSet({
                        title: '<BIG>�ڱ��β���Ѫѹǰ�A���Ƿ��˽��Լ���Ѫѹ����H</BIG>',
                        layout: 'column',
                        id: 'FSQ24||43^2||6^143',
                        columnWidth: 1,
                        border: false,
                        frame: true,
                        autoHeight: true,
                        //collapsed:false,
                        //collapsible:true,
                        collapseFirst: true
                    });
Field = new Ext.form.Radio({
                                id: 'Q24||43^24||43||8756',
                                boxLabel:'�ٻ��и�Ѫѹ',
                                checked: false,
                                hideLabel: true,
                                name:'Q24||43^2||6^143',
                                inputValue:'24||43||8756'
                            //,fieldLabel :SelectDesc
                            //,labelSeparator:''
                            });
var FieldPanel = new Ext.Panel({
                            layout: 'form',
                            items: Field,
                            id: 'PQ24||43^2||6^143^24||43||8756',
                            autoHeight: true,
                            columnWidth: obj.ElementNum,
                            style: ' padding:0px 0px  0px  10px;'
                        })
                        DetailFieldSets.add(FieldPanel);
Field = new Ext.form.Radio({
                                id: 'Q24||43^24||43||8757',
                                boxLabel:'��Ѫѹ����',
                                checked: false,
                                hideLabel: true,
                                name:'Q24||43^2||6^143',
                                inputValue:'24||43||8757'
                            //,fieldLabel :SelectDesc
                            //,labelSeparator:''
                            });
var FieldPanel = new Ext.Panel({
                            layout: 'form',
                            items: Field,
                            id: 'PQ24||43^2||6^143^24||43||8757',
                            autoHeight: true,
                            columnWidth: obj.ElementNum,
                            style: ' padding:0px 0px  0px  10px;'
                        })
                        DetailFieldSets.add(FieldPanel);
Field = new Ext.form.Radio({
                                id: 'Q24||43^24||43||8758',
                                boxLabel:'�۲���������',
                                checked: false,
                                hideLabel: true,
                                name:'Q24||43^2||6^143',
                                inputValue:'24||43||8758'
                            //,fieldLabel :SelectDesc
                            //,labelSeparator:''
                            });
var FieldPanel = new Ext.Panel({
                            layout: 'form',
                            items: Field,
                            id: 'PQ24||43^2||6^143^24||43||8758',
                            autoHeight: true,
                            columnWidth: obj.ElementNum,
                            style: ' padding:0px 0px  0px  10px;'
                        })
                        DetailFieldSets.add(FieldPanel);
Field = new Ext.form.Radio({
                                id: 'Q24||43^24||43||8759',
                                boxLabel:'�ܴ�δ���',
                                checked: false,
                                hideLabel: true,
                                name:'Q24||43^2||6^143',
                                inputValue:'24||43||8759'
                            //,fieldLabel :SelectDesc
                            //,labelSeparator:''
                            });
var FieldPanel = new Ext.Panel({
                            layout: 'form',
                            items: Field,
                            id: 'PQ24||43^2||6^143^24||43||8759',
                            autoHeight: true,
                            columnWidth: obj.ElementNum,
                            style: ' padding:0px 0px  0px  10px;'
                        })
                        DetailFieldSets.add(FieldPanel);
                    TitlePanel.add(DetailFieldSets);
Field = new Ext.form.NumberField({
                allowBlank:true,
                emptyText: obj.InputInfo,
                fieldLabel:'���ǵ���ǰ��������һ��Ѫѹֵ�Ƕ�����H ����ѹ',
                id:'Q24||43^24||43||8760',
                name:'Q24||43^2||6^24||43||8760',
                //vtypeText:'������',
                value:''
            });
            var FieldPanel = new Ext.Panel({
                layout: 'form',
                items: Field,
                id: 'PQ24||43^2||6^24||43||8760',
                columnWidth: obj.ElementNum
            })
            TitlePanel.add(FieldPanel);
Field = new Ext.form.NumberField({
                allowBlank:true,
                emptyText: obj.InputInfo,
                fieldLabel:'����ѹ',
                id:'Q24||43^24||43||8761',
                name:'Q24||43^2||6^24||43||8761',
                //vtypeText:'������',
                value:''
            });
            var FieldPanel = new Ext.Panel({
                layout: 'form',
                items: Field,
                id: 'PQ24||43^2||6^24||43||8761',
                columnWidth: obj.ElementNum
            })
            TitlePanel.add(FieldPanel);
var DetailFieldSets = new Ext.form.FieldSet({
                        title: '<BIG>���� 2 �����Ƿ���ý�ѹҩ�H</BIG>',
                        layout: 'column',
                        id: 'FSQ24||43^2||6^146',
                        columnWidth: 1,
                        border: false,
                        frame: true,
                        autoHeight: true,
                        //collapsed:false,
                        //collapsible:true,
                        collapseFirst: true
                    });
Field = new Ext.form.Radio({
                                id: 'Q24||43^24||43||8762',
                                boxLabel:'��',
                                checked: false,
                                hideLabel: true,
                                name:'Q24||43^2||6^146',
                                inputValue:'24||43||8762'
                            //,fieldLabel :SelectDesc
                            //,labelSeparator:''
                            });
var FieldPanel = new Ext.Panel({
                            layout: 'form',
                            items: Field,
                            id: 'PQ24||43^2||6^146^24||43||8762',
                            autoHeight: true,
                            columnWidth: obj.ElementNum,
                            style: ' padding:0px 0px  0px  10px;'
                        })
                        DetailFieldSets.add(FieldPanel);
Field = new Ext.form.Radio({
                                id: 'Q24||43^24||43||8763',
                                boxLabel:'��',
                                checked: false,
                                hideLabel: true,
                                name:'Q24||43^2||6^146',
                                inputValue:'24||43||8763'
                            //,fieldLabel :SelectDesc
                            //,labelSeparator:''
                            });
var FieldPanel = new Ext.Panel({
                            layout: 'form',
                            items: Field,
                            id: 'PQ24||43^2||6^146^24||43||8763',
                            autoHeight: true,
                            columnWidth: obj.ElementNum,
                            style: ' padding:0px 0px  0px  10px;'
                        })
                        DetailFieldSets.add(FieldPanel);
                    TitlePanel.add(DetailFieldSets);
var DetailFieldSets = new Ext.form.FieldSet({
                        title: '<BIG>�ڱ��β���Ѫ��ǰ�A���Ƿ��˽��Լ���Ѫ������H</BIG>',
                        layout: 'column',
                        id: 'FSQ24||43^2||6^147',
                        columnWidth: 1,
                        border: false,
                        frame: true,
                        autoHeight: true,
                        //collapsed:false,
                        //collapsible:true,
                        collapseFirst: true
                    });
Field = new Ext.form.Radio({
                                id: 'Q24||43^24||43||8764',
                                boxLabel:'�ٻ�������',
                                checked: false,
                                hideLabel: true,
                                name:'Q24||43^2||6^147',
                                inputValue:'24||43||8764'
                            //,fieldLabel :SelectDesc
                            //,labelSeparator:''
                            });
var FieldPanel = new Ext.Panel({
                            layout: 'form',
                            items: Field,
                            id: 'PQ24||43^2||6^147^24||43||8764',
                            autoHeight: true,
                            columnWidth: obj.ElementNum,
                            style: ' padding:0px 0px  0px  10px;'
                        })
                        DetailFieldSets.add(FieldPanel);
Field = new Ext.form.Radio({
                                id: 'Q24||43^24||43||8765',
                                boxLabel:'�ڻ��ո�Ѫ�����������������',
                                checked: false,
                                hideLabel: true,
                                name:'Q24||43^2||6^147',
                                inputValue:'24||43||8765'
                            //,fieldLabel :SelectDesc
                            //,labelSeparator:''
                            });
var FieldPanel = new Ext.Panel({
                            layout: 'form',
                            items: Field,
                            id: 'PQ24||43^2||6^147^24||43||8765',
                            autoHeight: true,
                            columnWidth: obj.ElementNum,
                            style: ' padding:0px 0px  0px  10px;'
                        })
                        DetailFieldSets.add(FieldPanel);
Field = new Ext.form.Radio({
                                id: 'Q24||43^24||43||8766',
                                boxLabel:'��Ѫ������',
                                checked: false,
                                hideLabel: true,
                                name:'Q24||43^2||6^147',
                                inputValue:'24||43||8766'
                            //,fieldLabel :SelectDesc
                            //,labelSeparator:''
                            });
var FieldPanel = new Ext.Panel({
                            layout: 'form',
                            items: Field,
                            id: 'PQ24||43^2||6^147^24||43||8766',
                            autoHeight: true,
                            columnWidth: obj.ElementNum,
                            style: ' padding:0px 0px  0px  10px;'
                        })
                        DetailFieldSets.add(FieldPanel);
Field = new Ext.form.Radio({
                                id: 'Q24||43^24||43||8767',
                                boxLabel:'�ܲ���� �����',
                                checked: false,
                                hideLabel: true,
                                name:'Q24||43^2||6^147',
                                inputValue:'24||43||8767'
                            //,fieldLabel :SelectDesc
                            //,labelSeparator:''
                            });
var FieldPanel = new Ext.Panel({
                            layout: 'form',
                            items: Field,
                            id: 'PQ24||43^2||6^147^24||43||8767',
                            autoHeight: true,
                            columnWidth: obj.ElementNum,
                            style: ' padding:0px 0px  0px  10px;'
                        })
                        DetailFieldSets.add(FieldPanel);
Field = new Ext.form.Radio({
                                id: 'Q24||43^24||43||8768',
                                boxLabel:'�ݴ�δ���',
                                checked: false,
                                hideLabel: true,
                                name:'Q24||43^2||6^147',
                                inputValue:'24||43||8768'
                            //,fieldLabel :SelectDesc
                            //,labelSeparator:''
                            });
var FieldPanel = new Ext.Panel({
                            layout: 'form',
                            items: Field,
                            id: 'PQ24||43^2||6^147^24||43||8768',
                            autoHeight: true,
                            columnWidth: obj.ElementNum,
                            style: ' padding:0px 0px  0px  10px;'
                        })
                        DetailFieldSets.add(FieldPanel);
                    TitlePanel.add(DetailFieldSets);
var DetailFieldSets = new Ext.form.FieldSet({
                        title: '<BIG>���� 2 �����Ƿ�ʹ���������򲡵�ҩ��H</BIG>',
                        layout: 'column',
                        id: 'FSQ24||43^2||6^148',
                        columnWidth: 1,
                        border: false,
                        frame: true,
                        autoHeight: true,
                        //collapsed:false,
                        //collapsible:true,
                        collapseFirst: true
                    });
Field = new Ext.form.Radio({
                                id: 'Q24||43^24||43||8769',
                                boxLabel:'����',
                                checked: false,
                                hideLabel: true,
                                name:'Q24||43^2||6^148',
                                inputValue:'24||43||8769'
                            //,fieldLabel :SelectDesc
                            //,labelSeparator:''
                            });
var FieldPanel = new Ext.Panel({
                            layout: 'form',
                            items: Field,
                            id: 'PQ24||43^2||6^148^24||43||8769',
                            autoHeight: true,
                            columnWidth: obj.ElementNum,
                            style: ' padding:0px 0px  0px  10px;'
                        })
                        DetailFieldSets.add(FieldPanel);
Field = new Ext.form.Radio({
                                id: 'Q24||43^24||43||8770',
                                boxLabel:'�ڷ�',
                                checked: false,
                                hideLabel: true,
                                name:'Q24||43^2||6^148',
                                inputValue:'24||43||8770'
                            //,fieldLabel :SelectDesc
                            //,labelSeparator:''
                            });
var FieldPanel = new Ext.Panel({
                            layout: 'form',
                            items: Field,
                            id: 'PQ24||43^2||6^148^24||43||8770',
                            autoHeight: true,
                            columnWidth: obj.ElementNum,
                            style: ' padding:0px 0px  0px  10px;'
                        })
                        DetailFieldSets.add(FieldPanel);
                    TitlePanel.add(DetailFieldSets);
var DetailFieldSets = new Ext.form.FieldSet({
                        title: '<BIG>�ڱ��β���Ѫ֬ǰ�A���Ƿ��˽��Լ���Ѫ֬����H</BIG>',
                        layout: 'column',
                        id: 'FSQ24||43^2||6^149',
                        columnWidth: 1,
                        border: false,
                        frame: true,
                        autoHeight: true,
                        //collapsed:false,
                        //collapsible:true,
                        collapseFirst: true
                    });
Field = new Ext.form.Radio({
                                id: 'Q24||43^24||43||8771',
                                boxLabel:'��Ѫ֬�쳣',
                                checked: false,
                                hideLabel: true,
                                name:'Q24||43^2||6^149',
                                inputValue:'24||43||8771'
                            //,fieldLabel :SelectDesc
                            //,labelSeparator:''
                            });
var FieldPanel = new Ext.Panel({
                            layout: 'form',
                            items: Field,
                            id: 'PQ24||43^2||6^149^24||43||8771',
                            autoHeight: true,
                            columnWidth: obj.ElementNum,
                            style: ' padding:0px 0px  0px  10px;'
                        })
                        DetailFieldSets.add(FieldPanel);
Field = new Ext.form.Radio({
                                id: 'Q24||43^24||43||8772',
                                boxLabel:'��Ѫ֬����',
                                checked: false,
                                hideLabel: true,
                                name:'Q24||43^2||6^149',
                                inputValue:'24||43||8772'
                            //,fieldLabel :SelectDesc
                            //,labelSeparator:''
                            });
var FieldPanel = new Ext.Panel({
                            layout: 'form',
                            items: Field,
                            id: 'PQ24||43^2||6^149^24||43||8772',
                            autoHeight: true,
                            columnWidth: obj.ElementNum,
                            style: ' padding:0px 0px  0px  10px;'
                        })
                        DetailFieldSets.add(FieldPanel);
Field = new Ext.form.Radio({
                                id: 'Q24||43^24||43||8773',
                                boxLabel:'�۲���������',
                                checked: false,
                                hideLabel: true,
                                name:'Q24||43^2||6^149',
                                inputValue:'24||43||8773'
                            //,fieldLabel :SelectDesc
                            //,labelSeparator:''
                            });
var FieldPanel = new Ext.Panel({
                            layout: 'form',
                            items: Field,
                            id: 'PQ24||43^2||6^149^24||43||8773',
                            autoHeight: true,
                            columnWidth: obj.ElementNum,
                            style: ' padding:0px 0px  0px  10px;'
                        })
                        DetailFieldSets.add(FieldPanel);
Field = new Ext.form.Radio({
                                id: 'Q24||43^24||43||8774',
                                boxLabel:'�ܴ�δ���',
                                checked: false,
                                hideLabel: true,
                                name:'Q24||43^2||6^149',
                                inputValue:'24||43||8774'
                            //,fieldLabel :SelectDesc
                            //,labelSeparator:''
                            });
var FieldPanel = new Ext.Panel({
                            layout: 'form',
                            items: Field,
                            id: 'PQ24||43^2||6^149^24||43||8774',
                            autoHeight: true,
                            columnWidth: obj.ElementNum,
                            style: ' padding:0px 0px  0px  10px;'
                        })
                        DetailFieldSets.add(FieldPanel);
                    TitlePanel.add(DetailFieldSets);
var DetailFieldSets = new Ext.form.FieldSet({
                        title: '<BIG>��֪���Լ�Ŀǰ��������H</BIG>',
                        layout: 'column',
                        id: 'FSQ24||43^2||6^150',
                        columnWidth: 1,
                        border: false,
                        frame: true,
                        autoHeight: true,
                        //collapsed:false,
                        //collapsible:true,
                        collapseFirst: true
                    });
Field = new Ext.form.Radio({
                                id: 'Q24||43^24||43||8775',
                                boxLabel:'��֪��',
                                checked: false,
                               hideLabel: true,
                               name:'Q24||43^2||6^150',
                               inputValue:'24||43||8775'
                            //,fieldLabel :SelectDesc
                            //,labelSeparator:''
                            });
var FieldPanel = new Ext.Panel({
                            layout: 'form',
                            items: Field,
                            id: 'PQ24||43^2||6^150^24||43||8775',
                            autoHeight: true,
                            columnWidth: obj.ElementNum,
                            style: ' padding:0px 0px  0px  10px;'
                        })
                        DetailFieldSets.add(FieldPanel);
Field = new Ext.form.Radio({
                                id: 'Q24||43^24||43||8776',
                                boxLabel:'�ڲ�֪��',
                                checked: false,
                                hideLabel: true,
                                name:'Q24||43^2||6^150',
                                inputValue:'24||43||8776'
                            //,fieldLabel :SelectDesc
                            //,labelSeparator:''
                            });
var FieldPanel = new Ext.Panel({
                            layout: 'form',
                            items: Field,
                            id: 'PQ24||43^2||6^150^24||43||8776',
                            autoHeight: true,
                            columnWidth: obj.ElementNum,
                            style: ' padding:0px 0px  0px  10px;'
                        })
                        DetailFieldSets.add(FieldPanel);
                    TitlePanel.add(DetailFieldSets);
QuestionPanel.add(TitlePanel);
var TitlePanel = new Ext.form.FieldSet({
        title: '<h1><BIG><BIG>���Ƿ�������֪�����������������H</BIG></BIG>',
       frame: true,
        autoHeight: true,
        layout: 'column',
        //layout:'table',
        collapsed: false,
        collapsible: true,
        collapseFirst: true,
        id: 'Q24||43^2||7'
    });
var DetailFieldSets = new Ext.form.FieldSet({
                        title: '<BIG>���Ĳ�</BIG>',
                        layout: 'column',
                        id: 'FSQ24||43^2||7^151',
                        columnWidth: 1,
                        border: false,
                        frame: true,
                        autoHeight: true,
                        //collapsed:false,
                        //collapsible:true,
                        collapseFirst: true
                    });
Field = new Ext.form.Radio({
                                id: 'Q24||43^24||43||8777',
                                boxLabel:'����',
                                checked: false,
                                hideLabel: true,
                                name:'Q24||43^2||7^151',
                                inputValue:'24||43||8777'
                            //,fieldLabel :SelectDesc
                            //,labelSeparator:''
                            });
var FieldPanel = new Ext.Panel({
                            layout: 'form',
                            items: Field,
                            id: 'PQ24||43^2||7^151^24||43||8777',
                            autoHeight: true,
                            columnWidth: obj.ElementNum,
                            style: ' padding:0px 0px  0px  10px;'
                        })
                        DetailFieldSets.add(FieldPanel);
Field = new Ext.form.Radio({
                                id: 'Q24||43^24||43||8778',
                                boxLabel:'�ڷ�',
                                checked: false,
                                hideLabel: true,
                                name:'Q24||43^2||7^151',
                                inputValue:'24||43||8778'
                            //,fieldLabel :SelectDesc
                            //,labelSeparator:''
                            });
var FieldPanel = new Ext.Panel({
                            layout: 'form',
                            items: Field,
                            id: 'PQ24||43^2||7^151^24||43||8778',
                            autoHeight: true,
                            columnWidth: obj.ElementNum,
                            style: ' padding:0px 0px  0px  10px;'
                        })
                        DetailFieldSets.add(FieldPanel);
                    TitlePanel.add(DetailFieldSets);
var DetailFieldSets = new Ext.form.FieldSet({
                        title: '<BIG>������</BIG>',
                        layout: 'column',
                        id: 'FSQ24||43^2||7^152',
                        columnWidth: 1,
                        border: false,
                        frame: true,
                        autoHeight: true,
                        //collapsed:false,
                        //collapsible:true,
                        collapseFirst: true
                    });
Field = new Ext.form.Radio({
                                id: 'Q24||43^24||43||8779',
                                boxLabel:'����',
                                checked: false,
                                hideLabel: true,
                                name:'Q24||43^2||7^152',
                                inputValue:'24||43||8779'
                            //,fieldLabel :SelectDesc
                            //,labelSeparator:''
                            });
var FieldPanel = new Ext.Panel({
                            layout: 'form',
                            items: Field,
                            id: 'PQ24||43^2||7^152^24||43||8779',
                            autoHeight: true,
                            columnWidth: obj.ElementNum,
                            style: ' padding:0px 0px  0px  10px;'
                        })
                        DetailFieldSets.add(FieldPanel);
Field = new Ext.form.Radio({
                                id: 'Q24||43^24||43||8780',
                                boxLabel:'�ڷ�',
                                checked: false,
                                hideLabel: true,
                                name:'Q24||43^2||7^152',
                                inputValue:'24||43||8780'
                            //,fieldLabel :SelectDesc
                            //,labelSeparator:''
                            });
var FieldPanel = new Ext.Panel({
                            layout: 'form',
                            items: Field,
                            id: 'PQ24||43^2||7^152^24||43||8780',
                            autoHeight: true,
                            columnWidth: obj.ElementNum,
                            style: ' padding:0px 0px  0px  10px;'
                        })
                        DetailFieldSets.add(FieldPanel);
                    TitlePanel.add(DetailFieldSets);
var DetailFieldSets = new Ext.form.FieldSet({
                        title: '<BIG>���������Էβ�����</BIG>',
                        layout: 'column',
                        id: 'FSQ24||43^2||7^153',
                        columnWidth: 1,
                        border: false,
                        frame: true,
                        autoHeight: true,
                        //collapsed:false,
                        //collapsible:true,
                        collapseFirst: true
                    });
Field = new Ext.form.Radio({
                                id: 'Q24||43^24||43||8781',
                                boxLabel:'����',
                                checked: false,
                                hideLabel: true,
                                name:'Q24||43^2||7^153',
                                inputValue:'24||43||8781'
                            //,fieldLabel :SelectDesc
                            //,labelSeparator:''
                            });
var FieldPanel = new Ext.Panel({
                            layout: 'form',
                            items: Field,
                            id: 'PQ24||43^2||7^153^24||43||8781',
                            autoHeight: true,
                            columnWidth: obj.ElementNum,
                            style: ' padding:0px 0px  0px  10px;'
                        })
                        DetailFieldSets.add(FieldPanel);
Field = new Ext.form.Radio({
                                id: 'Q24||43^24||43||8782',
                                boxLabel:'�ڷ�',
                                checked: false,
                                hideLabel: true,
                                name:'Q24||43^2||7^153',
                                inputValue:'24||43||8782'
                            //,fieldLabel :SelectDesc
                            //,labelSeparator:''
                            });
var FieldPanel = new Ext.Panel({
                            layout: 'form',
                            items: Field,
                            id: 'PQ24||43^2||7^153^24||43||8782',
                            autoHeight: true,
                            columnWidth: obj.ElementNum,
                            style: ' padding:0px 0px  0px  10px;'
                        })
                        DetailFieldSets.add(FieldPanel);
                    TitlePanel.add(DetailFieldSets);
var DetailFieldSets = new Ext.form.FieldSet({
                        title: '<BIG>��֢</BIG>',
                        layout: 'column',
                        id: 'FSQ24||43^2||7^154',
                        columnWidth: 1,
                        border: false,
                        frame: true,
                        autoHeight: true,
                        //collapsed:false,
                        //collapsible:true,
                        collapseFirst: true
                    });
Field = new Ext.form.Radio({
                                id: 'Q24||43^24||43||8783',
                                boxLabel:'����',
                                checked: false,
                                hideLabel: true,
                                name:'Q24||43^2||7^154',
                                inputValue:'24||43||8783'
                            //,fieldLabel :SelectDesc
                            //,labelSeparator:''
                            });
var FieldPanel = new Ext.Panel({
                            layout: 'form',
                            items: Field,
                            id: 'PQ24||43^2||7^154^24||43||8783',
                            autoHeight: true,
                            columnWidth: obj.ElementNum,
                            style: ' padding:0px 0px  0px  10px;'
                        })
                        DetailFieldSets.add(FieldPanel);
Field = new Ext.form.Radio({
                                id: 'Q24||43^24||43||8784',
                                boxLabel:'�ڷ�',
                                checked: false,
                                hideLabel: true,
                                name:'Q24||43^2||7^154',
                                inputValue:'24||43||8784'
                            //,fieldLabel :SelectDesc
                            //,labelSeparator:''
                            });
var FieldPanel = new Ext.Panel({
                            layout: 'form',
                            items: Field,
                            id: 'PQ24||43^2||7^154^24||43||8784',
                            autoHeight: true,
                            columnWidth: obj.ElementNum,
                            style: ' padding:0px 0px  0px  10px;'
                        })
                        DetailFieldSets.add(FieldPanel);
                    TitlePanel.add(DetailFieldSets);
QuestionPanel.add(TitlePanel);
var TitlePanel = new Ext.form.FieldSet({
        title: '<h1><BIG><BIG>����</BIG></BIG>',
       frame: true,
        autoHeight: true,
        layout: 'column',
        //layout:'table',
        collapsed: false,
        collapsible: true,
        collapseFirst: true,
        id: 'Q24||43^2||8'
    });
var DetailFieldSets = new Ext.form.FieldSet({
                        title: '<BIG>��ĿǰΪֹ�A�ϼ��������Ƿ����� 100 ֧�̻� 3 ����Ҷ�H</BIG>',
                        layout: 'column',
                        id: 'FSQ24||43^2||8^156',
                        columnWidth: 1,
                        border: false,
                        frame: true,
                        autoHeight: true,
                        //collapsed:false,
                        //collapsible:true,
                        collapseFirst: true
                    });
Field = new Ext.form.Radio({
                                id: 'Q24||43^24||43||8785',
                                boxLabel:'����',
                                checked: false,
                                hideLabel: true,
                                name:'Q24||43^2||8^156',
                                inputValue:'24||43||8785'
                            //,fieldLabel :SelectDesc
                            //,labelSeparator:''
                            });
var FieldPanel = new Ext.Panel({
                            layout: 'form',
                            items: Field,
                            id: 'PQ24||43^2||8^156^24||43||8785',
                            autoHeight: true,
                            columnWidth: obj.ElementNum,
                            style: ' padding:0px 0px  0px  10px;'
                        })
                        DetailFieldSets.add(FieldPanel);
Field = new Ext.form.Radio({
                                id: 'Q24||43^24||43||8786',
                                boxLabel:'�ڷ�',
                                checked: false,
                                hideLabel: true,
                                name:'Q24||43^2||8^156',
                                inputValue:'24||43||8786'
                            //,fieldLabel :SelectDesc
                            //,labelSeparator:''
                            });
var FieldPanel = new Ext.Panel({
                            layout: 'form',
                            items: Field,
                            id: 'PQ24||43^2||8^156^24||43||8786',
                            autoHeight: true,
                            columnWidth: obj.ElementNum,
                            style: ' padding:0px 0px  0px  10px;'
                        })
                        DetailFieldSets.add(FieldPanel);
                    TitlePanel.add(DetailFieldSets);
var DetailFieldSets = new Ext.form.FieldSet({
                        title: '<BIG>��ȥ 30 ��A���Ƿ����� 1 ֧���Ͼ��̡H�]���Դ���Ϊ��Ҷ�^</BIG>',
                        layout: 'column',
                        id: 'FSQ24||43^2||8^157',
                        columnWidth: 1,
                        border: false,
                        frame: true,
                        autoHeight: true,
                        //collapsed:false,
                        //collapsible:true,
                        collapseFirst: true
                    });
Field = new Ext.form.Radio({
                                id: 'Q24||43^24||43||8787',
                                boxLabel:'����',
                                checked: false,
                                hideLabel: true,
                                name:'Q24||43^2||8^157',
                                inputValue:'24||43||8787'
                            //,fieldLabel :SelectDesc
                            //,labelSeparator:''
                            });
var FieldPanel = new Ext.Panel({
                            layout: 'form',
                            items: Field,
                            id: 'PQ24||43^2||8^157^24||43||8787',
                            autoHeight: true,
                            columnWidth: obj.ElementNum,
                            style: ' padding:0px 0px  0px  10px;'
                        })
                        DetailFieldSets.add(FieldPanel);
Field = new Ext.form.Radio({
                                id: 'Q24||43^24||43||8788',
                                boxLabel:'�ڷ�',
                                checked: false,
                                hideLabel: true,
                                name:'Q24||43^2||8^157',
                                inputValue:'24||43||8788'
                            //,fieldLabel :SelectDesc
                            //,labelSeparator:''
                            });
var FieldPanel = new Ext.Panel({
                            layout: 'form',
                            items: Field,
                            id: 'PQ24||43^2||8^157^24||43||8788',
                            autoHeight: true,
                            columnWidth: obj.ElementNum,
                            style: ' padding:0px 0px  0px  10px;'
                        })
                        DetailFieldSets.add(FieldPanel);
                    TitlePanel.add(DetailFieldSets);
var DetailFieldSets = new Ext.form.FieldSet({
                        title: '<BIG>��ȥһ���СA�ܹ��ж��������˵������������̡H</BIG>',
                        layout: 'column',
                        id: 'FSQ24||43^2||8^158',
                        columnWidth: 1,
                        border: false,
                        frame: true,
                        autoHeight: true,
                        //collapsed:false,
                        //collapsible:true,
                        collapseFirst: true
                    });
Field = new Ext.form.Radio({
                                id: 'Q24||43^24||43||8789',
                                boxLabel:'��û��',
                                checked: false,
                                hideLabel: true,
                                name:'Q24||43^2||8^158',
                                inputValue:'24||43||8789'
                            //,fieldLabel :SelectDesc
                            //,labelSeparator:''
                            });
var FieldPanel = new Ext.Panel({
                            layout: 'form',
                            items: Field,
                            id: 'PQ24||43^2||8^158^24||43||8789',
                            autoHeight: true,
                            columnWidth: obj.ElementNum,
                            style: ' padding:0px 0px  0px  10px;'
                        })
                        DetailFieldSets.add(FieldPanel);
Field = new Ext.form.Radio({
                                id: 'Q24||43^24||43||8790',
                                boxLabel:'��1-2 ��',
                                checked: false,
                                hideLabel: true,
                                name:'Q24||43^2||8^158',
                                inputValue:'24||43||8790'
                            //,fieldLabel :SelectDesc
                            //,labelSeparator:''
                            });
var FieldPanel = new Ext.Panel({
                            layout: 'form',
                            items: Field,
                            id: 'PQ24||43^2||8^158^24||43||8790',
                            autoHeight: true,
                            columnWidth: obj.ElementNum,
                            style: ' padding:0px 0px  0px  10px;'
                        })
                        DetailFieldSets.add(FieldPanel);
Field = new Ext.form.Radio({
                                id: 'Q24||43^24||43||8791',
                                boxLabel:'��3-4 ��',
                                checked: false,
                                hideLabel: true,
                                name:'Q24||43^2||8^158',
                                inputValue:'24||43||8791'
                            //,fieldLabel :SelectDesc
                            //,labelSeparator:''
                            });
var FieldPanel = new Ext.Panel({
                            layout: 'form',
                            items: Field,
                            id: 'PQ24||43^2||8^158^24||43||8791',
                            autoHeight: true,
                            columnWidth: obj.ElementNum,
                            style: ' padding:0px 0px  0px  10px;'
                        })
                        DetailFieldSets.add(FieldPanel);
Field = new Ext.form.Radio({
                                id: 'Q24||43^24||43||8792',
                                boxLabel:'��5-6 ��',
                                checked: false,
                                hideLabel: true,
                                name:'Q24||43^2||8^158',
                                inputValue:'24||43||8792'
                            //,fieldLabel :SelectDesc
                            //,labelSeparator:''
                            });
var FieldPanel = new Ext.Panel({
                            layout: 'form',
                            items: Field,
                            id: 'PQ24||43^2||8^158^24||43||8792',
                            autoHeight: true,
                            columnWidth: obj.ElementNum,
                            style: ' padding:0px 0px  0px  10px;'
                        })
                        DetailFieldSets.add(FieldPanel);
Field = new Ext.form.Radio({
                                id: 'Q24||43^24||43||8793',
                                boxLabel:'��7 ��',
                                checked: false,
                                hideLabel: true,
                                name:'Q24||43^2||8^158',
                                inputValue:'24||43||8793'
                            //,fieldLabel :SelectDesc
                            //,labelSeparator:''
                            });
var FieldPanel = new Ext.Panel({
                            layout: 'form',
                            items: Field,
                            id: 'PQ24||43^2||8^158^24||43||8793',
                            autoHeight: true,
                            columnWidth: obj.ElementNum,
                            style: ' padding:0px 0px  0px  10px;'
                        })
                        DetailFieldSets.add(FieldPanel);
                    TitlePanel.add(DetailFieldSets);
var DetailFieldSets = new Ext.form.FieldSet({
                        title: '<BIG>��ȥһ���СA��ƽ��ÿ���ж೤ʱ�䴦�����������̵������СH</BIG>',
                        layout: 'column',
                        id: 'FSQ24||43^2||8^159',
                        columnWidth: 1,
                        border: false,
                        frame: true,
                        autoHeight: true,
                        //collapsed:false,
                        //collapsible:true,
                        collapseFirst: true
                    });
Field = new Ext.form.Radio({
                                id: 'Q24||43^24||43||8794',
                                boxLabel:'��û��',
                                checked: false,
                                hideLabel: true,
                                name:'Q24||43^2||8^159',
                                inputValue:'24||43||8794'
                            //,fieldLabel :SelectDesc
                            //,labelSeparator:''
                            });
var FieldPanel = new Ext.Panel({
                            layout: 'form',
                            items: Field,
                            id: 'PQ24||43^2||8^159^24||43||8794',
                            autoHeight: true,
                            columnWidth: obj.ElementNum,
                            style: ' padding:0px 0px  0px  10px;'
                        })
                        DetailFieldSets.add(FieldPanel);
Field = new Ext.form.Radio({
                                id: 'Q24||43^24||43||8795',
                                boxLabel:'��0-15 ����',
                                checked: false,
                                hideLabel: true,
                                name:'Q24||43^2||8^159',
                                inputValue:'24||43||8795'
                            //,fieldLabel :SelectDesc
                            //,labelSeparator:''
                            });
var FieldPanel = new Ext.Panel({
                            layout: 'form',
                            items: Field,
                            id: 'PQ24||43^2||8^159^24||43||8795',
                            autoHeight: true,
                            columnWidth: obj.ElementNum,
                            style: ' padding:0px 0px  0px  10px;'
                        })
                        DetailFieldSets.add(FieldPanel);
Field = new Ext.form.Radio({
                                id: 'Q24||43^24||43||8796',
                                boxLabel:' ��16-30 ����',
                                checked: false,
                                hideLabel: true,
                                name:'Q24||43^2||8^159',
                                inputValue:'24||43||8796'
                            //,fieldLabel :SelectDesc
                            //,labelSeparator:''
                            });
var FieldPanel = new Ext.Panel({
                            layout: 'form',
                            items: Field,
                            id: 'PQ24||43^2||8^159^24||43||8796',
                            autoHeight: true,
                            columnWidth: obj.ElementNum,
                            style: ' padding:0px 0px  0px  10px;'
                        })
                        DetailFieldSets.add(FieldPanel);
Field = new Ext.form.Radio({
                                id: 'Q24||43^24||43||8797',
                                boxLabel:'��31-60 ����',
                                checked: false,
                                hideLabel: true,
                                name:'Q24||43^2||8^159',
                                inputValue:'24||43||8797'
                            //,fieldLabel :SelectDesc
                            //,labelSeparator:''
                            });
var FieldPanel = new Ext.Panel({
                            layout: 'form',
                            items: Field,
                            id: 'PQ24||43^2||8^159^24||43||8797',
                            autoHeight: true,
                            columnWidth: obj.ElementNum,
                            style: ' padding:0px 0px  0px  10px;'
                        })
                        DetailFieldSets.add(FieldPanel);
Field = new Ext.form.Radio({
                                id: 'Q24||43^24||43||8798',
                                boxLabel:'��61 ����-2 Сʱ',
                                checked: false,
                                hideLabel: true,
                                name:'Q24||43^2||8^159',
                                inputValue:'24||43||8798'
                            //,fieldLabel :SelectDesc
                            //,labelSeparator:''
                            });
var FieldPanel = new Ext.Panel({
                            layout: 'form',
                            items: Field,
                            id: 'PQ24||43^2||8^159^24||43||8798',
                            autoHeight: true,
                            columnWidth: obj.ElementNum,
                            style: ' padding:0px 0px  0px  10px;'
                        })
                        DetailFieldSets.add(FieldPanel);
Field = new Ext.form.Radio({
                                id: 'Q24||43^24||43||8799',
                                boxLabel:'��2Сʱ����',
                                checked: false,
                                hideLabel: true,
                                name:'Q24||43^2||8^159',
                                inputValue:'24||43||8799'
                            //,fieldLabel :SelectDesc
                            //,labelSeparator:''
                            });
var FieldPanel = new Ext.Panel({
                            layout: 'form',
                            items: Field,
                            id: 'PQ24||43^2||8^159^24||43||8799',
                            autoHeight: true,
                            columnWidth: obj.ElementNum,
                            style: ' padding:0px 0px  0px  10px;'
                        })
                        DetailFieldSets.add(FieldPanel);
                    TitlePanel.add(DetailFieldSets);
QuestionPanel.add(TitlePanel);
var TitlePanel = new Ext.form.FieldSet({
        title: '<h1><BIG><BIG>�����</BIG></BIG>',
       frame: true,
        autoHeight: true,
        layout: 'column',
        //layout:'table',
        collapsed: false,
        collapsible: true,
        collapseFirst: true,
        id: 'Q24||43^2||9'
    });
Field = new Ext.form.NumberField({
                allowBlank:true,
                emptyText: obj.InputInfo,
                fieldLabel:'���',
                id:'Q24||43^24||43||8800',
                name:'Q24||43^2||9^24||43||8800',
                //vtypeText:'������',
                value:''
            });
            var FieldPanel = new Ext.Panel({
                layout: 'form',
                items: Field,
                id: 'PQ24||43^2||9^24||43||8800',
                columnWidth: obj.ElementNum
            })
            TitlePanel.add(FieldPanel);
Field = new Ext.form.NumberField({
                allowBlank:false,
                emptyText: obj.InputInfo,
                fieldLabel:'����',
                id:'Q24||43^24||43||8801',
                name:'Q24||43^2||9^24||43||8801',
                //vtypeText:'������',
                value:''
            });
            var FieldPanel = new Ext.Panel({
                layout: 'form',
                items: Field,
                id: 'PQ24||43^2||9^24||43||8801',
                columnWidth: obj.ElementNum
            })
            TitlePanel.add(FieldPanel);
Field = new Ext.form.NumberField({
                allowBlank:true,
                emptyText: obj.InputInfo,
                fieldLabel:'��Χ',
                id:'Q24||43^24||43||8802',
                name:'Q24||43^2||9^24||43||8802',
                //vtypeText:'������',
                value:''
            });
            var FieldPanel = new Ext.Panel({
                layout: 'form',
                items: Field,
                id: 'PQ24||43^2||9^24||43||8802',
                columnWidth: obj.ElementNum
            })
            TitlePanel.add(FieldPanel);
Field = new Ext.form.NumberField({
                allowBlank:true,
                emptyText: obj.InputInfo,
                fieldLabel:'Ѫѹ�]���ξ�ֵ�^ ����ѹ',
                id:'Q24||43^24||43||8803',
                name:'Q24||43^2||9^24||43||8803',
                //vtypeText:'������',
                value:''
            });
            var FieldPanel = new Ext.Panel({
                layout: 'form',
                items: Field,
                id: 'PQ24||43^2||9^24||43||8803',
                columnWidth: obj.ElementNum
            })
            TitlePanel.add(FieldPanel);
Field = new Ext.form.NumberField({
                allowBlank:true,
                emptyText: obj.InputInfo,
                fieldLabel:'����ѹ',
                id:'Q24||43^24||43||8804',
                name:'Q24||43^2||9^24||43||8804',
                //vtypeText:'������',
                value:''
            });
            var FieldPanel = new Ext.Panel({
                layout: 'form',
                items: Field,
                id: 'PQ24||43^2||9^24||43||8804',
                columnWidth: obj.ElementNum
            })
            TitlePanel.add(FieldPanel);
Field = new Ext.form.NumberField({
                allowBlank:true,
                emptyText: obj.InputInfo,
                fieldLabel:'�ո�Ѫ�� (FBG)',
                id:'Q24||43^24||43||8805',
                name:'Q24||43^2||9^24||43||8805',
                //vtypeText:'������',
                value:''
            });
            var FieldPanel = new Ext.Panel({
                layout: 'form',
                items: Field,
                id: 'PQ24||43^2||9^24||43||8805',
                columnWidth: obj.ElementNum
            })
            TitlePanel.add(FieldPanel);
Field = new Ext.form.NumberField({
                allowBlank:true,
                emptyText: obj.InputInfo,
                fieldLabel:' Ѫ�ܵ��̴�  (TC)',
                id:'Q24||43^24||43||8806',
                name:'Q24||43^2||9^24||43||8806',
                //vtypeText:'������',
                value:''
            });
            var FieldPanel = new Ext.Panel({
            layout: 'form',
                items: Field,
                id: 'PQ24||43^2||9^24||43||8806',
                columnWidth: obj.ElementNum
            })
            TitlePanel.add(FieldPanel);
Field = new Ext.form.NumberField({
                allowBlank:true,
                emptyText: obj.InputInfo,
                fieldLabel:'Ѫ������֬  (TG)',
                id:'Q24||43^24||43||8807',
                name:'Q24||43^2||9^24||43||8807',
                //vtypeText:'������',
                value:''
            });
            var FieldPanel = new Ext.Panel({
                layout: 'form',
                items: Field,
                id: 'PQ24||43^2||9^24||43||8807',
                columnWidth: obj.ElementNum
            })
            TitlePanel.add(FieldPanel);
Field = new Ext.form.NumberField({
                allowBlank:true,
                emptyText: obj.InputInfo,
                fieldLabel:'���ܶ�֬����(HDL)',
                id:'Q24||43^24||43||8808',
                name:'Q24||43^2||9^24||43||8808',
                //vtypeText:'������',
                value:''
            });
            var FieldPanel = new Ext.Panel({
                layout: 'form',
                items: Field,
                id: 'PQ24||43^2||9^24||43||8808',
                columnWidth: obj.ElementNum
            })
            TitlePanel.add(FieldPanel);
Field = new Ext.form.NumberField({
                allowBlank:true,
                emptyText: obj.InputInfo,
                fieldLabel:'���ܶ�֬����(LDL)',
                id:'Q24||43^24||43||8809',
                name:'Q24||43^2||9^24||43||8809',
                //vtypeText:'������',
                value:''
            });
            var FieldPanel = new Ext.Panel({
                layout: 'form',
                items: Field,
                id: 'PQ24||43^2||9^24||43||8809',
                columnWidth: obj.ElementNum
            })
            TitlePanel.add(FieldPanel);
QuestionPanel.add(TitlePanel);
//return QuestionPanel;


	obj.FormPanelT = new Ext.TabPanel({
		id : 'FormPanelT'
		,buttonAlign : 'center'
		,labelWidth : 80
		,labelAlign : 'right'
		,frame : true
		,title : '����'
		,region : 'center'
		,items:[
		]
	,	buttons:[
			obj.ButtonT
		]
	});
	obj.ViewportMain = new Ext.Viewport({
		id : 'ViewportMain'
		,layout : 'border'
		,items:[
			obj.FormPanelT
		]
	});
	InitViewportMainEvent(obj);
	//�¼��������
	obj.ButtonT.on("click", obj.ButtonT_click, obj);
  obj.LoadEvent(arguments);
  return obj;
}

