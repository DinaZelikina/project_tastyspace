import { useEffect } from 'react';
import RecipeDetails from './RecipeDetails';
import './RecipeList.css';
import { ActionButton } from '../ActionButtons';

type RecipeListProps = {
    recipeIds: number[];
    onBackToMenu: () => void;
    updateActionButtons: (buttons: ActionButton[]) => void;
};

// Display cooking instructions
export default function RecipeList({ recipeIds, onBackToMenu, updateActionButtons }: RecipeListProps) {
    useEffect(() => {
        updateActionButtons([
            { text: 'Back to Menu', action: onBackToMenu }
        ]);
    }, [updateActionButtons, onBackToMenu]);

    return (
        <>
            <h3 className="text-center">Cooking Instructions</h3>
            <div className="recipe-list">
                {recipeIds.map((recipeId) => (
                    <RecipeDetails key={recipeId} recipeId={recipeId} />
                ))}
            </div>
        </>
    );
}