//
//  PXFooterViewModelHelper.swift
//  MercadoPagoSDK
//
//  Created by Demian Tejo on 11/15/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import UIKit

internal extension PXResultViewModel {

    func getFooterComponentProps() -> PXFooterProps {
        return PXFooterProps(buttonAction: getActionButton(), linkAction: getActionLink())
    }

    func buildFooterComponent() -> PXFooterComponent {
        let footerProps = getFooterComponentProps()
        return PXFooterComponent(props: footerProps)
    }
}

// MARK: Build Helpers
internal extension PXResultViewModel {

    func getActionButton() -> PXAction? {
         var actionButton: PXAction?
        if let label = self.getButtonLabel(), let action = self.getButtonAction() {
            actionButton = PXAction(label: label, action: action)
        }
        return actionButton
    }

    func getActionLink() -> PXAction? {
        guard let labelLink = self.getLinkLabel(), let actionOfLink = self.getLinkAction() else {
            return nil
        }
        return PXAction(label: labelLink, action: actionOfLink)
    }

    private func getButtonLabel() -> String? {
        if paymentResult.isAccepted() {
            return nil
        } else if paymentResult.isError() {
            return PXFooterResultConstants.GENERIC_ERROR_BUTTON_TEXT.localized_beta
        } else if paymentResult.isWarning() {
            return getWarningButtonLabel()
        }
        return PXFooterResultConstants.DEFAULT_BUTTON_TEXT
    }

    private func getWarningButtonLabel() -> String? {
        if self.paymentResult.isCallForAuth() {
            return PXFooterResultConstants.C4AUTH_BUTTON_TEXT.localized_beta
        } else if self.paymentResult.isBadFilled() {
            return PXFooterResultConstants.BAD_FILLED_BUTTON_TEXT.localized_beta
        } else if self.paymentResult.isInvalidInstallments() {
            return PXFooterResultConstants.INVALID_INSTALLMENTS_BUTTON_TEXT.localized_beta
        } else if self.paymentResult.isDuplicatedPayment() {
            return PXFooterResultConstants.CARD_DISABLE_BUTTON_TEXT.localized_beta
        } else {
            return PXFooterResultConstants.GENERIC_ERROR_BUTTON_TEXT.localized_beta
        }
    }

    private func getLinkLabel() -> String? {
        if paymentResult.hasSecondaryButton() {
            return PXFooterResultConstants.GENERIC_ERROR_BUTTON_TEXT.localized_beta
        } else if paymentResult.isAccepted() {
            return PXFooterResultConstants.APPROVED_LINK_TEXT.localized_beta
        }
        return nil
    }

    private func getButtonAction() -> (() -> Void)? {
        return { self.pressButton() }
    }

    private func getLinkAction() -> (() -> Void)? {
        return { self.pressLink() }
    }

    private func pressButton() {
        guard let callback = self.callback else {return}
        if paymentResult.isAccepted() {
             callback(PaymentResult.CongratsState.cancel_EXIT)
        } else if paymentResult.isError() {
             callback(PaymentResult.CongratsState.cancel_SELECT_OTHER)
        } else if paymentResult.isWarning() {
            if self.paymentResult.statusDetail == PXRejectedStatusDetail.CALL_FOR_AUTH.rawValue || self.paymentResult.statusDetail == PXRejectedStatusDetail.INSUFFICIENT_AMOUNT.rawValue {
                callback(PaymentResult.CongratsState.cancel_SELECT_OTHER)
            } else {
                callback(PaymentResult.CongratsState.cancel_RETRY)
            }
        }
    }

    private func pressLink() {
        if paymentResult.isAccepted() {
            if let callback = self.callback {
                callback(PaymentResult.CongratsState.cancel_EXIT)
            }
        }
    }
}
