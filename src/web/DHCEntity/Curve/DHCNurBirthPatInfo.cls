Class web.DHCEntity.Curve.DHCNurBirthPatInfo Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right, Not ProcedureBlock ]
{

/// DHCCurve_Adm
Property DHCCurveAdm As %String(TRUNCATE = 1);

/// DHCCurve_Pregnancy
Property DHCCurvePregnancy As %String(TRUNCATE = 1);

/// DHCCurve_ContraDate
Property DHCCurveContraDate As %Library.Date(FORMAT = 1);

/// DHCCurve_ContraTime
Property DHCCurveContraTime As %Library.Time;

/// DHCCurve_UserID
Property DHCCurveUserID As %String(TRUNCATE = 1);

Property BirthDate As %Library.Date;

Property BirthTime As %Library.Time;

Property BirthCount As %String(TRUNCATE = 1);

Property PredictPreg As %String;

Property PlacentaOutDate As %Library.Date;

Property PlacentaOutTime As %Library.Time;

}
