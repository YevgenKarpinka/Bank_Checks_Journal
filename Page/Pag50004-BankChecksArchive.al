page 50004 "Bank Checks Archive"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Documents;
    SourceTable = "Bank Check Journal Line";
    SourceTableView = where(Status = filter(<> New));

    layout
    {
        area(Content)
        {
            repeater(RepeaterName)
            {
                field(Status; Status)
                {
                    ApplicationArea = All;
                }
                field(ID; ID)
                {
                    ApplicationArea = All;
                }
                field("Bank Check Date"; "Bank Check Date")
                {
                    ApplicationArea = All;
                }
                field("Bank Check No."; "Bank Check No.")
                {
                    ApplicationArea = All;
                }
                field("Customer No."; "Customer No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field(Amount; Amount)
                {
                    ApplicationArea = All;
                }
                field("Source No."; "Source No.")
                {
                    ApplicationArea = All;
                }
                field("Source Type"; "Source Type")
                {
                    ApplicationArea = All;
                }
                field("Last Modified DateTime"; "Last Modified DateTime")
                {
                    ApplicationArea = All;
                }
                field("User ID"; "User ID")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Confirm)
            {
                ApplicationArea = All;
                Image = Approval;

                trigger OnAction()
                var
                    _BankCheck: Record "Bank Check Journal Line";
                begin
                    CurrPage.SetSelectionFilter(_BankCheck);
                    _BankCheckMgt.SetBankCheckStatus(_BankCheck, _BankCheck.Status::New);
                    CurrPage.Update(false);
                end;
            }
            // action(Refuse)
            // {
            //     ApplicationArea = All;
            //     Image = Reject;

            //     trigger OnAction()
            //     var
            //         _BankCheck: Record "Bank Check Journal Line";
            //     begin
            //     end;
            // }
        }
    }

    var
        _BankCheckMgt: Codeunit "Bank Checks Mgt.";
}