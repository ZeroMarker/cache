function InitViewportMain(){
	var obj = new Object();
	obj.ElementNum=1/3
	obj.InputInfo="请录入..."
	obj.ButtonT = new Ext.Button({
		id : 'ButtonT'
		,text : '添加form'
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
        title: '<h1><BIG><BIG>慢病家族史</BIG></BIG>',
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
                        title: '<BIG>高血压家族史</BIG>',
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
                                boxLabel:'父亲',
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
                                boxLabel:'母亲',
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
                                boxLabel:'兄弟姐妹',
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
                                boxLabel:'子女',
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
                        title: '<BIG>糖尿病家族史</BIG>',
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
                                boxLabel:'父亲',
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
                                boxLabel:'母亲',
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
                                boxLabel:'兄弟姐妹',
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
                                boxLabel:'子女',
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
                        title: '<BIG>糖尿病家族史</BIG>',
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
                                boxLabel:'父亲',
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
                                boxLabel:'母亲',
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
                                boxLabel:'兄弟姐妹',
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
                                boxLabel:'子女',
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
                        title: '<BIG>糖尿病家族史</BIG>',
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
                                boxLabel:'父亲',
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
                                boxLabel:'母亲',
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
                                boxLabel:'兄弟姐妹',
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
                                boxLabel:'子女',
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
                        title: '<BIG>脑卒中家族史</BIG>',
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
                                boxLabel:'父亲',
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
                                boxLabel:'母亲',
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
                                boxLabel:'兄弟姐妹',
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
                                boxLabel:'子女',
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
                        title: '<BIG>肥胖家族史</BIG>',
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
                                boxLabel:'父亲',
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
                                boxLabel:'母亲',
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
                                boxLabel:'兄弟姐妹',
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
                                boxLabel:'子女',
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
                        title: '<BIG>癌症家族史</BIG>',
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
                                boxLabel:'父亲',
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
                                boxLabel:'母亲',
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
                                boxLabel:'兄弟姐妹',
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
                                boxLabel:'子女',
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
        title: '<h1><BIG><BIG>慢病病史及慢病知晓治疗情况</BIG></BIG>',
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
                        title: '<BIG>在本次测量血压前您是否了解自己的血压情况</BIG>',
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
                                boxLabel:'①患有高血压',
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
                                boxLabel:'②血压正常',
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
                                boxLabel:'③测过但不清楚',
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
                                boxLabel:'④从未测过',
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
                fieldLabel:'您记得以前测过的最高一次血压值是多少吗 收缩压',
                id:'Q24||43^24||43||8760',
                name:'Q24||43^2||6^24||43||8760',
                //vtypeText:'请输入',
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
                fieldLabel:'舒张压',
                id:'Q24||43^24||43||8761',
                name:'Q24||43^2||6^24||43||8761',
                //vtypeText:'请输入',
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
                        title: '<BIG>您近 2 周内是否服用降压药</BIG>',
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
                                boxLabel:'是',
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
                                boxLabel:'否',
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
                        title: '<BIG>在本次测量血糖前您是否了解自己的血糖情况</BIG>',
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
                                boxLabel:'①患有糖尿病',
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
                                boxLabel:'②患空腹血糖受损或糖耐量受损',
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
                                boxLabel:'③血糖正常',
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
                                boxLabel:'④测过但 不清楚',
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
                                boxLabel:'⑤从未测过',
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
                        title: '<BIG>您近 2 周内是否使用治疗糖尿病的药物</BIG>',
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
                                boxLabel:'①是',
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
                                boxLabel:'②否',
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
                        title: '<BIG>在本次测量血脂前您是否了解自己的血脂情况</BIG>',
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
                                boxLabel:'①血脂异常',
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
                                boxLabel:'②血脂正常',
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
                                boxLabel:'③测过但不清楚',
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
                                boxLabel:'④从未测过',
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
                        title: '<BIG>您知道自己目前的体重吗</BIG>',
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
                                boxLabel:'①知道',
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
                                boxLabel:'②不知道',
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
        title: '<h1><BIG><BIG>您是否曾被告知患有以下其他慢病</BIG></BIG>',
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
                        title: '<BIG>冠心病</BIG>',
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
                                boxLabel:'①是',
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
                                boxLabel:'②否',
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
                        title: '<BIG>脑卒中</BIG>',
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
                                boxLabel:'①是',
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
                                boxLabel:'②否',
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
                        title: '<BIG>慢性阻塞性肺部疾病</BIG>',
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
                                boxLabel:'①是',
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
                                boxLabel:'②否',
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
                        title: '<BIG>癌症</BIG>',
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
                                boxLabel:'①是',
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
                                boxLabel:'②否',
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
        title: '<h1><BIG><BIG>吸烟</BIG></BIG>',
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
                        title: '<BIG>到目前为止合计起来您是否吸足 100 支烟或 3 两烟叶</BIG>',
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
                                boxLabel:'①是',
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
                                boxLabel:'②否',
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
                        title: '<BIG>过去 30 天您是否吸过 1 支以上卷烟可以代换为烟叶</BIG>',
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
                                boxLabel:'①是',
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
                                boxLabel:'②否',
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
                        title: '<BIG>过去一周中总共有多少天有人当着您的面吸烟</BIG>',
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
                                boxLabel:'①没有',
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
                                boxLabel:'②1-2 天',
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
                                boxLabel:'③3-4 天',
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
                                boxLabel:'④5-6 天',
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
                                boxLabel:'⑤7 天',
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
                        title: '<BIG>过去一周中您平均每天有多长时间处于其他人吸烟的烟雾中</BIG>',
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
                                boxLabel:'①没有',
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
                                boxLabel:'②0-15 分钟',
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
                                boxLabel:' ③16-30 分钟',
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
                                boxLabel:'④31-60 分钟',
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
                                boxLabel:'⑤61 分钟-2 小时',
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
                                boxLabel:'⑥2小时以上',
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
        title: '<h1><BIG><BIG>体格检查</BIG></BIG>',
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
                fieldLabel:'身高',
                id:'Q24||43^24||43||8800',
                name:'Q24||43^2||9^24||43||8800',
                //vtypeText:'请输入',
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
                fieldLabel:'体重',
                id:'Q24||43^24||43||8801',
                name:'Q24||43^2||9^24||43||8801',
                //vtypeText:'请输入',
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
                fieldLabel:'腰围',
                id:'Q24||43^24||43||8802',
                name:'Q24||43^2||9^24||43||8802',
                //vtypeText:'请输入',
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
                fieldLabel:'血压两次均值 收缩压',
                id:'Q24||43^24||43||8803',
                name:'Q24||43^2||9^24||43||8803',
                //vtypeText:'请输入',
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
                fieldLabel:'舒张压',
                id:'Q24||43^24||43||8804',
                name:'Q24||43^2||9^24||43||8804',
                //vtypeText:'请输入',
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
                fieldLabel:'空腹血糖 (FBG)',
                id:'Q24||43^24||43||8805',
                name:'Q24||43^2||9^24||43||8805',
                //vtypeText:'请输入',
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
                fieldLabel:' 血总胆固醇  (TC)',
                id:'Q24||43^24||43||8806',
                name:'Q24||43^2||9^24||43||8806',
                //vtypeText:'请输入',
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
                fieldLabel:'血甘油三脂  (TG)',
                id:'Q24||43^24||43||8807',
                name:'Q24||43^2||9^24||43||8807',
                //vtypeText:'请输入',
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
                fieldLabel:'高密度脂蛋白(HDL)',
                id:'Q24||43^24||43||8808',
                name:'Q24||43^2||9^24||43||8808',
                //vtypeText:'请输入',
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
                fieldLabel:'低密度脂蛋白(LDL)',
                id:'Q24||43^24||43||8809',
                name:'Q24||43^2||9^24||43||8809',
                //vtypeText:'请输入',
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
		,title : '测试'
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
	//事件处理代码
	obj.ButtonT.on("click", obj.ButtonT_click, obj);
  obj.LoadEvent(arguments);
  return obj;
}

