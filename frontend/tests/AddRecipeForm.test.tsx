import { render, screen, fireEvent, waitFor } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { MemoryRouter, Route, Routes } from 'react-router-dom';
import { describe, expect, it, vi } from 'vitest';
import AddRecipeForm from '../src/components/addrecipe/AddRecipeForm';
import { mockedFetch } from './setup';

describe('AddRecipeForm', () => {
    const renderForm = () => {
        render(
            <MemoryRouter>
                <Routes>
                    <Route path="/" element={<AddRecipeForm onAddRecipe={() => {}} />} />
                </Routes>
            </MemoryRouter>
        );
        const titleInput = screen.getByLabelText('Title:');
        const descriptionInput = screen.getByLabelText('Description:');
        const ingredientNameInput = screen.getAllByPlaceholderText('Ingredient name')[0];
        const ingredientAmountInput = screen.getAllByPlaceholderText('Amount')[0];
        const ingredientMeasurementInput = screen.getByDisplayValue('-');
        const stepInput = screen.getByLabelText('Step 1');
        const submitButton = screen.getByText('Submit Recipe');
        return { titleInput, descriptionInput, ingredientNameInput, ingredientAmountInput, ingredientMeasurementInput, stepInput, submitButton };
    };

    it('renders the add recipe form', () => {
        const { titleInput, descriptionInput, ingredientNameInput, ingredientAmountInput, ingredientMeasurementInput, stepInput, submitButton } = renderForm();
        expect(titleInput).toBeInTheDocument();
        expect(descriptionInput).toBeInTheDocument();
        expect(ingredientNameInput).toBeInTheDocument();
        expect(ingredientAmountInput).toBeInTheDocument();
        expect(ingredientMeasurementInput).toBeInTheDocument();
        expect(stepInput).toBeInTheDocument();
        expect(submitButton).toBeInTheDocument();
    });

    it('gives an error if the title already exists', async () => {
        mockedFetch.mockImplementationOnce(async (path: string) => {
            if (path.includes('/check_recipe_title')) {
                return { ok: true, json: () => ({ exists: true }) };
            }
            return { ok: true, json: () => ({}) };
        });

        const { titleInput } = renderForm();
        await userEvent.type(titleInput, 'Existing Recipe');
        fireEvent.blur(titleInput);
        await waitFor(() => {
            const error = screen.queryByText('A recipe with this title already exists');
            expect(error).toBeInTheDocument();
        });
    });

    it('handles input validation for ingredient amount field', async () => {
        const { ingredientAmountInput, submitButton } = renderForm();
        await userEvent.type(ingredientAmountInput, 'invalid');
        fireEvent.blur(ingredientAmountInput);
        fireEvent.submit(submitButton);

        await waitFor(() => {
            const error = screen.queryByText('Please enter a valid amount');
            expect(error).toBeInTheDocument();
        });
    });

    it('handles input validation for ingredient field', async () => {
        const { ingredientNameInput, submitButton } = renderForm();
        fireEvent.blur(ingredientNameInput);
        fireEvent.submit(submitButton);

        await waitFor(() => {
            const error = screen.queryByText('Please fill out the ingredients correctly');
            expect(error).toBeInTheDocument();
        });
    });

    it('handles input validation for step field', async () => {
        const { stepInput, submitButton } = renderForm();
        fireEvent.blur(stepInput);
        fireEvent.submit(submitButton);

        await waitFor(() => {
            const error = screen.queryByText('Please fill out the cooking instructions');
            expect(error).toBeInTheDocument();
        });
    });

    it('submits the form correctly', async () => {
        const mockOnAddRecipe = vi.fn();
        render(
            <MemoryRouter>
                <Routes>
                    <Route path="/" element={<AddRecipeForm onAddRecipe={mockOnAddRecipe} />} />
                </Routes>
            </MemoryRouter>
        );

        const titleInput = screen.getByLabelText('Title:');
        const descriptionInput = screen.getByLabelText('Description:');
        const ingredientNameInput = screen.getAllByPlaceholderText('Ingredient name')[0];
        const ingredientAmountInput = screen.getAllByPlaceholderText('Amount')[0];
        const ingredientMeasurementInput = screen.getByDisplayValue('-');
        const stepInput = screen.getByLabelText('Step 1');
        const submitButton = screen.getByText('Submit Recipe');

        await userEvent.type(titleInput, 'New Recipe');
        await userEvent.type(descriptionInput, 'This is a description');
        await userEvent.type(ingredientNameInput, 'Sugar');
        await userEvent.type(ingredientAmountInput, '1');
        fireEvent.change(ingredientMeasurementInput, { target: { value: 'cup' } });
        await userEvent.type(stepInput, 'Mix all ingredients');
        fireEvent.submit(submitButton);

        await waitFor(() => {
            expect(mockOnAddRecipe).toHaveBeenCalled();
        });
    });
});
