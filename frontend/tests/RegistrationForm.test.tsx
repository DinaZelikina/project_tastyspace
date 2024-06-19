import { render, screen, fireEvent, waitFor } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { MemoryRouter, Route, Routes } from 'react-router-dom';
import { describe, expect, it, vi } from 'vitest';
import RegistrationForm from '../src/components/authorization/RegistrationForm';

describe('RegistrationForm', () => {
    const renderForm = () => {
        const mockSetUserToken = vi.fn();
        render(
            <MemoryRouter>
                <Routes>
                    <Route path="/" element={<RegistrationForm role="user" setUserToken={mockSetUserToken} />} />
                </Routes>
            </MemoryRouter>
        );
        const usernameInput = screen.getByPlaceholderText('Username');
        const passwordInput = screen.getByPlaceholderText('Password');
        const confirmPasswordInput = screen.getByPlaceholderText('Confirm Password');
        const emailInput = screen.getByPlaceholderText('Email');
        const submitButton = screen.getByText('Sign up');
        return { usernameInput, passwordInput, confirmPasswordInput, emailInput, submitButton, mockSetUserToken };
    };

    it('gives an error if the username already exists', async () => {
        global.fetch = vi.fn(async (path) => {
            if (path.includes('/check_username')) {
                return { ok: true, json: async () => ({ valid: true }) };
            }
            return { ok: true, json: async () => ({}) };
        });

        const { usernameInput } = renderForm();
        await userEvent.type(usernameInput, 'ExistingUser');
        fireEvent.blur(usernameInput);

        await waitFor(() => {
            const error = screen.queryByText('This username already exists, please choose another one');
            expect(error).toBeInTheDocument();
        });
    });

    it('handles input validation for confirm password field', async () => {
        const { passwordInput, confirmPasswordInput } = renderForm();
        await userEvent.type(passwordInput, 'password123');
        await userEvent.type(confirmPasswordInput, 'password124');
        
        fireEvent.blur(confirmPasswordInput);

        await waitFor(() => {
            const error = screen.queryByText('Passwords do not match');
            expect(error).toBeInTheDocument();
        });
    });

    it('handles input validation for email field', async () => {
        const { emailInput } = renderForm();
        await userEvent.type(emailInput, 'invalid-email');
        fireEvent.blur(emailInput);

        await waitFor(() => {
            const error = screen.queryByText('Please enter a valid email address');
            expect(error).toBeInTheDocument();
        });
    });

    it('clears errors when valid input is provided', async () => {
        const { usernameInput, passwordInput, confirmPasswordInput, emailInput } = renderForm();
        
        // Test username
        await userEvent.type(usernameInput, 'ValidUser');
        fireEvent.blur(usernameInput);
        await waitFor(() => {
            const error = screen.queryByText('This username already exists, please choose another one');
            expect(error).not.toBeInTheDocument();
        });

        // Test password
        await userEvent.type(passwordInput, 'password123');
        await userEvent.type(confirmPasswordInput, 'password123');
        fireEvent.blur(confirmPasswordInput);
        await waitFor(() => {
            const error = screen.queryByText('Passwords do not match');
            expect(error).not.toBeInTheDocument();
        });

        // Test email
        await userEvent.type(emailInput, 'valid@example.com');
        fireEvent.blur(emailInput);
        await waitFor(() => {
            const error = screen.queryByText('Please enter a valid email address');
            expect(error).not.toBeInTheDocument();
        });
    });

    it('submits the form correctly when all fields are valid', async () => {
        global.fetch = vi.fn(async (path) => {
            if (path.includes('/register')) {
                return { ok: true, json: async () => ({ access_token: 'mockToken' }) };
            }
            return { ok: true, json: async () => ({}) };
        });

        const { usernameInput, passwordInput, confirmPasswordInput, emailInput, submitButton, mockSetUserToken } = renderForm();
        
        await userEvent.type(usernameInput, 'NewUser');
        await userEvent.type(passwordInput, 'password123');
        await userEvent.type(confirmPasswordInput, 'password123');
        await userEvent.type(emailInput, 'valid@example.com');
        fireEvent.click(submitButton);

        await waitFor(() => {
            expect(mockSetUserToken).toHaveBeenCalledWith('mockToken');
        });
    });
});
