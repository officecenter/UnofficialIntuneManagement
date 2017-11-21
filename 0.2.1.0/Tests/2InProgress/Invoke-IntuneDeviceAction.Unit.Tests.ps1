Remove-Module UnofficialIntuneManagement
Import-Module "c:\git\UnofficialIntuneManagement"

InModuleScope UnofficialIntuneManagement {
    Describe '(UNIT TEST) Invoke-IntuneDeviceAction' {

        Context 'Should NOT fail checks' {
            ## Mocks that makes external modules succeed
            Mock Invoke-GraphAPI
                        
            $DeviceID = 'e0bda564-2630-442c-b5ca-488d514e79bc'
            $Action = "RebootNow"
            
            It 'Does not Throw' {
                { Invoke-IntuneDeviceAction -DeviceID $DeviceID -Action $Action -ErrorAction Stop } | Should Not Throw
            }    
        }
    }
}
