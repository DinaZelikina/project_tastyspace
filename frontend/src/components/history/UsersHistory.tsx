import React, { useState, useEffect } from 'react';
import './UsersHistory.css';
import { BACKEND_URL } from '../../App'; 

type User = {
    id: number;
    username: string;
    role: string;
    created: string;
    edited: string;
    last: string;
    saved_menus_count: number | string;
    recipes_count: number | string;
    moderated_recipes_count: number | string;
};

export default function UsersHistory() {
    const [users, setUsers] = useState<User[]>([]);
    const [searchTerm, setSearchTerm] = useState<string>('');
    const [sortBy, setSortBy] = useState<string>('id');

    useEffect(() => {
        const token = localStorage.getItem('access_token');
        fetch(`${BACKEND_URL}/usersHistory`, {
            headers: {
                'Authorization': `Bearer ${token}`
            }
        })
        .then(response => response.json())
        .then(data => {
            setUsers(data);
        })
        .catch(error => console.error('Error fetching users history:', error));
    }, []);

    const handleSearch = (e: React.ChangeEvent<HTMLInputElement>) => {
        setSearchTerm(e.target.value);
    };

    const handleSortChange = (e: React.ChangeEvent<HTMLSelectElement>) => {
        setSortBy(e.target.value);
    };

    const filteredUsers = users.filter(user => user.username.toLowerCase().includes(searchTerm.toLowerCase()));

    const parseDate = (dateString: string) => {
        if (dateString === '-') return null;
        const [day, month, year] = dateString.split('.').map(Number);
        return new Date(year, month - 1, day); 
    };


    const sortedUsers = [...filteredUsers].sort((a, b) => {
        if (sortBy === 'username') return a.username.localeCompare(b.username);
        if (sortBy === 'role') return a.role.localeCompare(b.role);
        if (sortBy === 'created') return new Date(a.created).getTime() - new Date(b.created).getTime();
        if (sortBy === 'last') return parseDate(a.last).getTime() - parseDate(b.last).getTime();
        return 0;
    });

    return (
        <div>
            <h2>Users History</h2>
            <div className="filters">
                <input
                    type="text"
                    placeholder="Search by username..."
                    value={searchTerm}
                    onChange={handleSearch}
                />
                <div>
                    <label><span className="label-text">Sort by:</span> </label>
                    <select value={sortBy} onChange={handleSortChange}>
                        <option value="username">Username</option>
                        <option value="role">Role</option>
                        <option value="created">Created date</option>
                        <option value="last">Last login</option>
                    </select>
                </div>
                <div className="user-count">
                    Showing {sortedUsers.length} of {users.length} users
                </div>
            </div>
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Username</th>
                        <th>Role</th>
                        <th>Created</th>
                        <th>Edited</th>
                        <th>Last Login</th>
                        <th className="center-align">Saved Menus</th>
                        <th className="center-align">Added Recipes</th>
                        <th className="center-align">Moderated Recipes</th>
                    </tr>
                </thead>
                <tbody>
                    {sortedUsers.length === 0 ? (
                        <tr>
                            <td colSpan={9}>No users found.</td>
                        </tr>
                    ) : (
                        sortedUsers.map(user => (
                            <tr key={user.id}>
                                <td>{user.id}</td>
                                <td>{user.username}</td>
                                <td>{user.role}</td>
                                <td>{user.created}</td>
                                <td>{user.edited}</td>
                                <td>{user.last}</td>
                                <td className="center-align">{user.saved_menus_count}</td>
                                <td className="center-align">{user.recipes_count}</td>
                                <td className="center-align">{user.moderated_recipes_count}</td>
                            </tr>
                        ))
                    )}
                </tbody>
            </table>
        </div>
    );
}
